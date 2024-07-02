defmodule DataStore do
  use Agent
  require Logger

  @moduledoc """
  DataStore is a temprorary storage for data. Any data that was not processed successfully
  will be stored in the DataStore.
  """

  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
    Task.start_link(fn -> loop() end)
  end

  def loop do
    receive do
      _ -> :ok
    after
      7_000 -> attempt_push()
    end

    loop()
  end

  def value do
    Agent.get(__MODULE__, & &1)
  end

  def add(v) do
    Logger.info "Added data to DataStore"
    Agent.update(__MODULE__, &([v|&1]))

  end

  def update_all(v) do
    Logger.info "Added data to DataStore"
    Agent.update(__MODULE__, fn _state -> v end)
    :ok

  end


  defp attempt_push do
    if length(value()) > 0 do
      Logger.warn "Attempting to push data..."
      value() |> push(0)
    end


  end



  defp push([head | tail], n) do
    #loops and dispatch data in the list
    result = Dispatcher.dispatch_call(head)


    if result == true do
      push(tail, n+1)
    else
      Logger.error "Push failed. Only #{n} items were pushed!"
      Agent.get(__MODULE__, fn _s -> [head | tail] end)
    end


  end

  defp push([], n) do
    update_all([]) #Remove data
    Logger.info "All data was submitted! number of pushed Items: #{n}"
  end

end
