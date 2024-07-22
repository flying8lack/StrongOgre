
defmodule Project do
  @moduledoc """
  Documentation for `Project`.
  """
  require Dispatcher
  require Logger


  def init do
    children = [
      %{
        id: Dispatcher,
        start: {Dispatcher, :start_link, ["FC7LX25K33J3BQND"]}
      },
      %{
        id: Sensor_1,
        start: {InputEvent, :start_link, [0, "FC7LX25K33J3BQND"]}
      },
      %{
        id: Sensor_2,
        start: {InputEvent, :start_link, [0, "FC7LX25K33J3BQND"]}
      },
      %{
        id: Setting,
        start: {Setting, :start_link, [%{"time" => 5_000}]}
      },
      %{
        id: DataStore,
        start: {DataStore, :start_link, []}
      },
      %{
        id: NetworkMonitor,
        start: {NetworkMonitor, :start_link, []}
      }
    ]

    options =  [strategy: :one_for_one,
     max_restarts: 5,
    max_seconds: 10]
    Logger.info "Program Started"
    {:ok, sup_pid} = Supervisor.start_link(children, options)

    Logger.debug "Supervisor started at #{inspect sup_pid}"
    Logger.debug "Time between samples is set on #{Setting.get_data("time")} mili-seconds"
    #Metric.check_average_ping()
    Setting.set_data("sup_id", sup_pid)
    #Logger.critical Process.alive?(sup_pid)


  end

  def stop do
    Supervisor.stop(Setting.get_data("sup_id"))
  end

  def test_fail do
    GenServer.cast(Dispatcher, :shutdown)
  end

end

Project.init()
