require Dispatcher
require Logger


defmodule Project do
  @moduledoc """
  Documentation for `Project`.
  """

  def init do
    children = [
      # The Counter is a child started via Counter.start_link(0)
      %{
        id: Dispatcher,
        start: {Dispatcher, :start_link, [0]}
      }
    ]
    Logger.info "Program Started"
    #{:ok, pid} = GenServer.start_link(Dispatcher, [])
    {:ok, sup_pid} = Supervisor.start_link(children, strategy: :one_for_one)
    Logger.debug "Supervisor started at #{inspect sup_pid}"
  end

  def hello(pid, key, value) do


    GenServer.cast(Dispatcher, {:dispatch, key, value})
  end

  def test do

    Project.hello(pid, "FC7LX25K33J3BQND", 0)
  end

end

Project.init()
