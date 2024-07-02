defmodule Metric do

  defp check(name) do
    if !File.exists?("/metrics/#{name}.txt") do
      File.write("/metrics/#{name}.txt", "")
    end
  end

  defp save_data(name, value) do
    check(name)
    {:ok, file} = File.open!("/metrics/#{name}.txt")
    IO.binwrite(file, Float.to_string(value))
    File.close(file)

  end

  def get_current_time do
    System.system_time(:millisecond)
  end


end
