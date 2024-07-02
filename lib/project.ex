require Dispatcher



defmodule Project do
  @moduledoc """
  Documentation for `Project`.
  """

  require Logger


  def init do
    children = [
      %{
        id: Dispatcher,
        start: {Dispatcher, :start_link, ["FC7LX25K33J3BQND"]}
      },
      %{
        id: Sensor,
        start: {InputEvent, :start_link, []}
      },
      %{
        id: Setting,
        start: {Setting, :start_link, [%{"time" => 5_000}]}
      },
      %{
        id: DataStore,
        start: {DataStore, :start_link, []}
      }
    ]
    Logger.info "Program Started"
    {:ok, sup_pid} = Supervisor.start_link(children, strategy: :one_for_one)
    Logger.debug "Supervisor started at #{inspect sup_pid}"
    Supervisor.count_children(sup_pid)
    Logger.debug "Time between samples is set on #{Setting.get_data("time")} mili-seconds"
    test_dispatcher()
  end

  def test_dispatcher do


    {time, _} = :timer.tc(fn key, value -> GenServer.cast(Dispatcher, {:dispatch, key, value}) end, [self(), 0])
    Logger.info "Broadcasting took #{time} ms!"
  end


  def set_data(select, value) do

    Setting.set_data(select, value)
    :ok
  end

  def test_fail do

    GenServer.call(Dispatcher, 1)
  end

end
