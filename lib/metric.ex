defmodule Metric do
  require Logger

  defp check(name) do
    if !File.exists?("/metrics/#{name}.txt") do
      File.write("/metrics/#{name}.txt", "")
    end
  end

  defp save_data(name, value) do
    check(name)
    {:ok, file} = File.open(File.cwd!<>"/metrics/#{name}.txt", [:append])
    IO.binwrite(file, Integer.to_string(value)<>"\n")
    File.close(file)
  end

  def save_sending_time(old, new) do
    save_data("publish_time", new - old)
    Logger.debug "It took #{new - old} ms to send data"
  end

  def get_current_time do
    System.system_time(:millisecond)
  end


end
