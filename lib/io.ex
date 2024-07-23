


defmodule InputEvent do
  require Logger
  use Task, restart: :permanent

  def start_link(pin, key) do
    Task.start_link(fn -> loop(pin, key, [0]) end)
  end

  defp is_fault?(sample, state) do
    #check if sensor is stuck at fault
    Enum.all?(state, fn e -> sample == e end)
  end



  defp add_value(v, state, pid) do
    #check if the past number of values excedded the maximum amount (4). if it is, it will remove the oldest value.
    #it will update the new state.
    Logger.debug "Add value to state. current state length: #{Enum.count(state)}"
    if Enum.count(state) > Setting.get_data("minimum_fault_detection") do
      new_state = [v | state] |> Enum.drop( Setting.get_data("minimum_fault_detection")  - Enum.count(state) )
      send(pid, {new_state})
    else
      new_state = [v | state]
      send(pid, {new_state})
    end
  end

  defp sample_and_send(pin, key, state, pid) when is_integer(pin) do
    sample = round(1)
    if !is_fault?(sample, state) do
      Dispatcher.dispatch(self(), sample, key)
    else
      Logger.critical("STUCK AT FAULT #{sample} SENSOR #{pin}")
    end
    add_value(sample,state, pid)
  end

  defp sample_and_send(pin, key, state, pid)  do
    {:ok, field} = Circuits.GPIO.open(pin, :input)
    sample = Circuits.GPIO.read(field)
    if !is_fault?(sample, state) do
      Dispatcher.dispatch(self(), sample, key)
    end
    add_value(sample,state, pid)
    Circuits.GPIO.close(field)

  end

  defp loop(pin, key, state) do
    #sample every 15 seconds
    receive do
      {new_state} -> loop(pin, key, new_state)
      _ -> Logger.warn "Process recieved a message that was not expecting message!"
    after
      Setting.get_data("time") -> sample_and_send(pin, key, state, self())
    end

    loop(pin, key, state)
  end

end
