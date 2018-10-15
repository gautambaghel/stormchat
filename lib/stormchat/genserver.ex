defmodule Stormchat.CallAPI do
  use GenServer

  # Client
  def start_link do
    init_state = Stormchat.Locations.list_locations_abbr
    state = for {k, _} <- init_state, into: %{}, do: {k, get_data_from_external_server(k)}
    GenServer.start_link(__MODULE__, state, name: :weather_alert)
  end

  def init(state) do
    schedule_work() # Schedule work to be performed on start
    {:ok, state}
  end

  def get_weather(location) do
    GenServer.call(:weather_alert, {:weather, location})
  end

  def get_state do
    GenServer.call(:weather_alert, :get_state)
  end

  def stop do
    GenServer.call(:weather_alert, :stop)
  end

  # Server (callbacks)
  # def handle_call({:weather, location}, _from, state) do
  #   location_data = get_data_from_external_server(location)
  #   state = state |> Map.put(location, location_data)
  #   {:reply, location_data, state}
  # end

  def handle_call(:stop, _from, state) do
    {:stop, :normal, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:work, state) do
    # Do the desired work here
    state = for {k, v} <- state, into: %{}, do: {k, split_on_location(k,v)}
    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp split_on_location(location, data) do
    updated_state = get_data_from_external_server(location)
    check_new_key(location, updated_state, data)
    updated_state # send the updates state to become the new one
  end

  defp check_new_key(location, new, old) do
    new_keys =  Map.keys(new) -- Map.keys(old)
    if new_keys != [] do
      subscribed_users_of_location = Stormchat.Accounts.list_by_location_sub(location)
      data_arr = for x <- new_keys, do: get_desc_for_id(x)
      data = Enum.join(data_arr, " <br><br><br> ")
      data = "#{data}#{"<br><br>"}#{"  <a href=\"https://stormchat.gautambaghel.com\">Visit Stormchat @ Sushiparty</a> "}"

      for user <- subscribed_users_of_location, do: Stormchat.Mailer.send_alert_email(user,data)
    end
  end

  def terminate(reason, _status) do
    IO.puts "Asked to stop because #{inspect reason}"
    :ok
  end

  def get_data_from_external_server(location) do
    url = "https://api.weather.gov/alerts/active"
    headers = ["Accept": "application/vnd.noaa.dwml+xml;version=1"]
    final_url = "#{url}#{"/area/"}#{location}"
    with {:ok, content} <-  HTTPoison.get(final_url, headers,[timeout: 100_000, recv_timeout: 100_000]) do
      data = Poison.decode!(content.body)
      data = data["features"]
      dataMap = Enum.reduce data, %{}, fn x, acc ->
        Map.put(acc, x["properties"]["id"],
        %{"event" => x["properties"]["event"],
        "id" => x["properties"]["id"],
        "response" => x["properties"]["response"],
        "severity" => x["properties"]["severity"],
        "description" => x["properties"]["description"],
        "category" => x["properties"]["category"],
        "areaDesc" => x["properties"]["areaDesc"],
        "headline" => x["properties"]["headline"]})
      end
      dataMap
    else
      err ->
        IO.inspect(err)
        Process.send_after(self(), :work, 1000)
        []
    end
  end

  def get_lim_data_from_external_server(location) do
    url = "https://api.weather.gov/alerts/active"
    headers = ["Accept": "application/vnd.noaa.dwml+xml;version=1"]
    final_url = "#{url}#{"/area/"}#{location}"
    with {:ok, content} <-  HTTPoison.get(final_url, headers,[timeout: 100_000, recv_timeout: 100_000]) do
      data = Poison.decode!(content.body)
      data = data["features"]
      dataMap = Enum.reduce data, %{}, fn x, acc ->
        Map.put(acc, x["properties"]["id"],
        %{"id" => x["properties"]["id"],
        "event" => x["properties"]["event"],
        "areaDesc" => x["properties"]["areaDesc"],
        "headline" => x["properties"]["headline"]})
      end
      dataMap
    else
      err ->
        IO.inspect(err)
        Process.send_after(self(), :work, 1000)
        []
    end
  end

  def get_data_for_id(id) do
    url = "https://api.weather.gov/alerts/"
    headers = ["Accept": "application/vnd.noaa.dwml+xml;version=1"]
    final_url = "#{url}#{id}"
    with {:ok, content} <- HTTPoison.get(final_url, headers) do
      data = Poison.decode!(content.body)
      data["properties"]
    else
      err ->
        IO.inspect(err)
        Process.send_after(self(), :work, 1000)
        []
    end
  end

  defp get_desc_for_id(id) do
    url = "https://api.weather.gov/alerts/"
    headers = ["Accept": "application/vnd.noaa.dwml+xml;version=1"]
    final_url = "#{url}#{id}"
    with {:ok, content} <- HTTPoison.get(final_url, headers) do
      data = Poison.decode!(content.body)
      filler = " for "
      data = "#{data["properties"]["headline"]}#{filler}#{data["properties"]["areaDesc"]}"
      data
    else
      err ->
        IO.inspect(err)
        Process.send_after(self(), :work, 1000)
        []
    end
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 2 * 60 * 60 * 1000) # In 2 hour
  end

end
