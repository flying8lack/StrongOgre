


defmodule InputEvent do
  require Logger
  use Task, restart: :permanent

  def start_link(pin) do
    Task.start_link(fn -> loop(pin) end)
  end

  defp sample_and_send(_pin) do
    sample = 2 + 2
    Dispatcher.dispatch(self(), sample)

  end


  defp loop(pin) do
    #sample every 15 seconds
    receive do
      _ -> Logger.warning "Process recieved a message that was not expecting message!"
    after
      Setting.get_data("time") -> sample_and_send(pin)
    end

    loop(pin)
  end

end
