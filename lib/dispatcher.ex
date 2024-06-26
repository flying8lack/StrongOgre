


defmodule Dispatcher do

  require HTTPoison
  require Logger
  use GenServer

  @moduledoc """
  The dispatcher is a server process that dispatch data recieved from client. client is other processes
  that need to forword data to the cloud. the server exposes some client API to use. CALLING SERVER API SHOULD BE
  AVOIDED AT ALL COSTS.
  """


  # Callbacks

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  # Client API

  def dispatch(value) do
    GenServer.cast(Dispatcher, {:dispatch, value})
  end
  #Server API

  @impl true
  def init(api_key) when is_binary(api_key) do
    Logger.info "Server has configured to API_KEY: #{api_key}"
    {:ok, %{"key" => api_key}}
  end

  defp response(e) do
    Logger.info "request successful. Status code: #{e.status_code}"
    Logger.debug "Received response from API (get request)"
  end

  @impl true
  def handle_cast({:dispatch, element}, state) when is_binary(element) do
    Logger.debug "Received cast request request"
    resp = HTTPoison.get("https://api.thingspeak.com/update?api_key=" <> state["key"] <> "&field1=" <> element)
    case resp do
      {:ok, e} -> response(e)
      {:error, err} -> Logger.error "REQUEST FAILED. REASON: #{err.reason}"

    end


    {:noreply, state}
  end

  @impl true
  def handle_cast({:dispatch, element}, state) do
    Logger.debug "Received cast request request"
    resp = HTTPoison.get("https://api.thingspeak.com/update?api_key=" <> state["key"] <> "&field1=" <> Integer.to_string(element))
    case resp do
      {:ok, e} -> response(e)
      {:error, err} -> Logger.error "REQUEST FAILED. REASON: #{err.reason}"

    end


    {:noreply, state}
  end

  @doc """
  A call that return data upon request

  Returns `:ok`.

  ## Examples

      iex> GenServer.cast(Dispatcher, 22)
      2
      iex> GenServer.cast(Dispatcher, 40)
      40

  """

  @impl true
  def handle_call(data, _from, state) do
    {:reply, data, state}
  end

end
