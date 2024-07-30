defmodule DataStore do
  use Agent, restart: :permanent
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
      500 -> attempt_push()
    end

    loop()
  end

  def value do
    Agent.get(__MODULE__, & &1)
  end

  def add(v, key) do
    Logger.info "Added data to DataStore"
    Agent.update(__MODULE__, fn state -> [[v, key]|state] end)#&([v|&1]))

  end

  def update_all(v) do
    Logger.info "Added data to DataStore"
    Agent.update(__MODULE__, fn _state -> v end)

  end


  defp attempt_push do
    if length(value()) > 0 do
      Logger.warn "Attempting to push data..."
      value() |> Enum.reverse |> push(0)
    end


  end



  defp push([head | tail], n) do
    #loops and dispatch data in the list
    result = Dispatcher.dispatch_call(Enum.at(head, 0), Enum.at(head, 1))


    if result == true do
      push(tail, n+1)
    else
      Logger.error "Push failed. Only #{n} items were pushed!"
      Agent.get(__MODULE__, fn _s -> [head | tail] end)
      :error
    end


  end

  defp push([], n) do
    update_all([]) #Remove data
    Logger.info "All data was submitted! number of pushed Items: #{n}"
  end

end
