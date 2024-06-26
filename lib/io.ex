


defmodule InputEvent do
  require Logger
  use Task, restart: :permanent

  def start_link(_arg) do
    Task.start_link(&loop/0)
    Agent.start_link(fn -> 5_000 end, name: __MODULE__)
  end

  defp sample_and_send do
    sample = 2 + 2
    Dispatcher.dispatch(sample)

  end

  defp loop do
    #sample every 15 seconds
    receive do
      {:message_type, value} -> Logger.warning value
    after
      5_000 -> sample_and_send()
    end

    loop()
  end

end
