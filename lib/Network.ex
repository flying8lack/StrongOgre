defmodule NetworkMonitor do
  def start_link do
    Task.start_link(fn -> loop(:up, Metric.get_current_time()) end)
  end


  def loop(:down, old) do
    if connected?() do
      Metric.save_network_mttr(old, Metric.get_current_time())
      loop(:up, Metric.get_current_time())
    else
      loop(:down, old)
    end
  end

  def loop(:up, last_fail) do
    if not connected?() do
      Metric.save_network_mtbf(last_fail, Metric.get_current_time())
      loop(:down, Metric.get_current_time)
    else
      loop(:up, last_fail) #tail call
    end
  end

  defp connected? do
    case :inet.gethostbyname('google.com') do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end
end
