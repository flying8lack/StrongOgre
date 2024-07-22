


defmodule InputEvent do
  require Logger
  use Task, restart: :permanent

  def start_link(pin, key) do
    Task.start_link(fn -> loop(pin, key) end)
  end

  defp sample_and_send(pin, key) when is_integer(pin) do
      Dispatcher.dispatch(self(), :rand.uniform(), key)
  end

  defp sample_and_send(pin, key)  do
    {:ok, field} = Circuits.GPIO.open(pin, :input)
    sample = Circuits.GPIO.read(field)
    Dispatcher.dispatch(self(), sample, key)
    Circuits.GPIO.close(field)
  end

  defp loop(pin, key) do
    #sample every 15 seconds
    receive do
      _ -> Logger.warning "Process recieved a message that was not expecting message!"
    after
      Setting.get_data("time") -> sample_and_send(pin, key)
    end

    loop(pin, key)
  end

end
