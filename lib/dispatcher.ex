require Logger
require HTTPoison

defmodule Dispatcher do

  use GenServer

  # Callbacks

  def start_link(arg) when is_integer(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_stack) do
    {:ok, []}
  end

  @impl true
  def handle_cast({:dispatch, api_key, element}, state) do
    Logger.debug "Received cast request request"
    {:ok, e} = HTTPoison.get("https://api.thingspeak.com/update?api_key=" <> api_key <> "&field1=" <> Integer.to_string(element))
    Logger.debug "Received response from API (get request)"
    Logger.info "Status code: #{e.status_code}"
    {:noreply, state}
  end

end
