defmodule Stormchat.CallAPI do
  use GenServer

   # Client
   def start_link(opts) do
     GenServer.start_link(__MODULE__, %{}, opts)
   end

   def init(state) do
     schedule_work() # Schedule work to be performed on start
     {:ok, state}
   end

   def get_weather(pid, location) do
     GenServer.call(pid, {:weather, location})
   end

   def stop(pid) do
     GenServer.call(pid, :stop)
   end

   # Server (callbacks)
   def handle_call({:weather, location}, _from, state) do
     location_data = get_data_from_external_server(location)
     state = state |> Map.put(location, location_data)
     {:reply, location_data, state}
   end

   def handle_info(:work, state) do
     # Do the desired work here
     state = for {k, v} <- state, into: %{}, do: {k, get_data_from_external_server(k)}
     schedule_work() # Reschedule once more
     {:noreply, state}
   end

   def handle_call(:stop, _from, status) do
     {:stop, :normal, status}
   end

   def terminate(reason, _status) do
     IO.puts "Asked to stop because #{inspect reason}"
     :ok
   end

   def get_data_from_external_server(location) do
     url = "https://api.weather.gov/alerts/active"
     headers = ["Accept": "application/vnd.noaa.dwml+xml;version=1"]
     final_url = "#{url}#{"/area/"}#{location}"
     {:ok, content} = HTTPoison.get(final_url, headers)
     data = Poison.decode!(content.body)
     data = data["features"]
     data
   end

   defp schedule_work() do
    Process.send_after(self(), :work, 1 * 60 * 60 * 1000) # In 1 hour
   end

end
