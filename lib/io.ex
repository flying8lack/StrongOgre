


defmodule InputEvent do
  require Logger
  use Task, restart: :permanent

  def start_link do
    Task.start_link(&loop/0)
  end

  defp sample_and_send do
    sample = 2 + 2
    Dispatcher.dispatch(sample)

  end

  defp loop do
    #sample every 15 seconds
    receive do
      _ -> Logger.warning "Process recieved a message that was not expecting message!"
    after
      Setting.get_data("time") -> sample_and_send()
    end

    loop()
  end

end
