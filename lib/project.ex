require Dispatcher
require Logger


defmodule Project do
  @moduledoc """
  Documentation for `Project`.
  """

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
      }
    ]
    Logger.info "Program Started"
    {:ok, sup_pid} = Supervisor.start_link(children, strategy: :one_for_one)
    Logger.debug "Supervisor started at #{inspect sup_pid}"
    Supervisor.count_children(sup_pid)
    Logger.debug "Time between samples is set on #{Setting.get_data("time")}"
  end

  def hello(key, value) do


    GenServer.cast(Dispatcher, {:dispatch, key, value})
  end


  def test do

    Dispatcher.dispatch(5)
  end

  def test_fail do

    GenServer.call(Dispatcher, 1)
  end

end
