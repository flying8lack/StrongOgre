defmodule Setting do

  @moduledoc """
  A module that holds information about the system's configuration
  """
  use Agent
  def start_link(data) do
    Agent.start_link(fn -> data end, name: __MODULE__)
  end



  def get_data(select \\ "time") when is_binary(select) do

    data = Agent.get(__MODULE__, & &1)
    data[select]
  end

  def set_data(select, value) when is_binary(select) do

    Agent.update(__MODULE__, fn state -> Map.put(state, select, value) end)
  end


end
