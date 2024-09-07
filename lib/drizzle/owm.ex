defmodule Drizzle.OWM do
  @moduledoc """
  Module to query Open Weather Map
  """
  require Logger

  @location Application.compile_env(:drizzle, :location, %{
              latitude: 39.3898838,
              longitude: -104.8287546
            })

  @appid Application.compile_env(:drizzle, :appid)

  def query() do
    endpoint = owm_api_endpoint()
    params = owm_api_params()

    with {:ok, data} <- fetch_weather_information(endpoint, params) do
      normalize(data)
    end
  end

  def normalize(%{
        "hourly" => hourly,
        "lat" => lat,
        "lon" => lon
      })
      when is_list(hourly) do
    normalized =
      Map.new()
      |> add("coordinates", %{"lat" => lat, "lon" => lon})
      |> add("hourly", hourly |> Enum.map(&normalize_hourly_list/1))

    {:ok, normalized}
  end

  defp normalize_hourly_list(
         %{
           "dt" => dt,
           "pop" => prob_of_precipitation,
           "temp" => temp,
           "wind_speed" => wind_speed
         } = hour
       ) do
    rain = get_in(hour, ["rain", "1h"])

    %{
      "dt" => dt,
      "pop" => prob_of_precipitation,
      "temp" => temp,
      "wind_speed" => wind_speed,
      "rain" => rain || 0
    }
  end

  defp add(map, key, value) do
    map
    |> Map.put(key, value)
  end

  defp owm_api_endpoint() do
    "https://api.openweathermap.org/data/2.5/onecall"
  end

  defp owm_api_params() do
    %{
      lat: @location.latitude,
      lon: @location.longitude,
      appid: @appid,
      exclude: "minutely,current,daily,alerts",
      units: "imperial"
    }
  end

  defp fetch_weather_information(endpoint, opts) do
    case HTTPoison.get(endpoint, [], params: opts) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Poison.decode!(body)}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, :not_found}

      {:ok, %HTTPoison.Response{status_code: 400}} ->
        {:error, :not_found}

      {:ok, %HTTPoison.Response{status_code: 401}} ->
        {:error, :api_key_invalid}

      error = {:error, _reason} ->
        error
    end
  end

  # def init(state) do
  # Logger.info("Starting forecaster")
  ## TODO: Remove
  # Weather.get_todays_forecast()
  # schedule_work()
  # {:ok, state}
  # end

  # def handle_info(:work, state) do
  # Logger.info("Checking weather forecast")
  ## Get the forecast from Darksky and update the Agent
  # Weather.get_todays_forecast()

  # schedule_work()
  # {:noreply, state}
  # end

  # defp schedule_work() do
  ## Every Hour
  # Process.send_after(self(), :work, 60 * 60 * 1000)
  # end
end
