defmodule Metric do
  require Logger

  defp check(name) do
    if !File.exists?("/metrics/#{name}.txt") do
      File.write("/metrics/#{name}.txt", "")
    end
  end

  defp ping_server(host, port) do
    {time, _} = :timer.tc(fn ->
      {:ok, socket} = :gen_tcp.connect(host, port, [])
      :ok = :gen_tcp.close(socket)
    end)

    # Convert microseconds to milliseconds
    time / 1_000
  end

  def check_average_ping do
    avg = check_average_ping("www.google.com", 22)/22
  end

  def check_average_ping(host, n) when n > 0 do
    ping_server(host, 80) + check_average_ping(host, n - 1)
  end

  def check_average_ping(host, 0) do
    ping_server(host, 80)
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
