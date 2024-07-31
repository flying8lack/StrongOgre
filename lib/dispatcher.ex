


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

  def dispatch(pid, value, key) do
    GenServer.cast(Dispatcher, {:dispatch, pid, value, key, Metric.get_current_time()})
  end

  def dispatch_call(value, key) do
    GenServer.call(Dispatcher, {:dispatch, value, key})
  end
  #Server API


  @impl true
  def init(api_key) when is_binary(api_key) do
    Logger.info "Server has configured!"
    {:ok, %{"key" => api_key, "data_store" => []}}
  end

  defp push_response(result, return_v, state) do
    if result == true do
      Logger.info "Push was successful"

    else
      Logger.error "PUSH REQUEST FAILED."
    end

    {:reply, return_v, state}

  end



  defp response(e, start_time) do
    Logger.info "request successful. Status code: #{e.status_code}"
    Logger.debug "Received response from API (get request)"
    Metric.save_sending_time(start_time,Metric.get_current_time())

  end


  defp error_response(e,v, key) do
    Logger.error "REQUEST FAILED. REASON: #{e.reason}"
    DataStore.add(v, key)
  end

  @impl true
  def handle_cast(:shutdown, state) do

    raise "SYSTEM ERROR SIMULATION!"



    {:noreply, state}


  end

  @impl true
  def handle_cast({:dispatch, pid, element, key, start_time}, state) when is_float(element) do
    Logger.debug "Received cast request request from #{inspect pid}: #{element}"


    resp = HTTPoison.get("https://api.thingspeak.com/update?api_key=" <> key <> "&field1=" <> Float.to_string(element))
    #Tortoise.publish(MyClient, "channels/33301/publish/fields/field1", Float.to_string(element))
    case resp do
      {:ok, e} -> response(e, start_time)
      {:error, err} -> error_response(err, element, key)

    end




    {:noreply, state}


  end

  @impl true
  def handle_cast({:dispatch, pid, element, key, start_time}, state) do
    Logger.debug "Received cast request request from #{inspect pid}: #{element}"



    resp = HTTPoison.get("https://api.thingspeak.com/update?api_key=" <> key <> "&field1=" <> Integer.to_string(element))
    case resp do
      {:ok, e} -> response(e, start_time)
      {:error, err} -> error_response(err, element, key)

    end




    {:noreply, state}


  end

  @impl true
  def handle_call({:dispatch, element, key}, _from, state) when is_float(element) do
    Logger.info "Attempt push by datastore!"
    resp = HTTPoison.get("https://api.thingspeak.com/update?api_key=" <> key <> "&field1=" <> Float.to_string(element))
    case resp do
      {:ok, _e} -> push_response(true, true, state)
      {:error, _err} -> push_response(false, false, state)

    end



  end


  @impl true
  def handle_call({:dispatch, element, key}, _from, state) do
    Logger.info "Attempt push by datastore!"
    resp = HTTPoison.get("https://api.thingspeak.com/update?api_key=" <> key <> "&field1=" <> Integer.to_string(element))
    case resp do
      {:ok, _e} -> push_response(true, true, state)
      {:error, _err} -> push_response(false, false, state)

    end



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
