defmodule NetworkMonitor do
  def start_link do
    Task.start_link(fn -> monitor_network end)
  end

  defp monitor_network do
    loop(:up, 0)
  end

  defp loop(:up, downtime) do
    if connected? do
      if downtime > 0 do
        IO.puts "Network was down for #{downtime} seconds"
      end
      :timer.sleep(1000)
      loop(:up, 0)
    else
      loop(:down, downtime)
    end
  end

  defp loop(:down, downtime) do
    :timer.sleep(1000)
    if connected? do
      loop(:up, downtime)
    else
      loop(:down, downtime + 1)
    end
  end

  defp connected? do
    case :inet.gethostbyname('google.com') do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end
end
