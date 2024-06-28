defmodule Setting do
  use Agent
  def start_link(data) when is_map(data) do
    Agent.start_link(fn -> data end, name: __MODULE__)
  end

  def get_data(select \\ "time") when is_binary(select) do

    data = Agent.get(__MODULE__, & &1)
    data[select]
  end

  def set_data(select, value) when is_binary(select) do

    Agent.update(__MODULE__, &(value))
  end


end
