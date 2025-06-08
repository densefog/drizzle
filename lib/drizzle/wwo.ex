defmodule Drizzle.WWO do
  @moduledoc """
  Module to query World Weather Online
  """
  require Logger

  @location Application.compile_env(:drizzle, :location, %{
              latitude: 39.3898838,
              longitude: -104.8287546
            })

  @appid Application.compile_env(:drizzle, :appid)

  def query() do
    endpoint = wwo_api_endpoint()
    params = wwo_api_params()

    with {:ok, data} <- fetch_weather_information(endpoint, params) do
      normalize(data)
    end
  end

  def normalize(%{
        "data" => %{
          "weather" => [
            %{
              "maxtempF" => max_temp,
              "mintempF" => min_temp,
              "hourly" => [%{"chanceofrain" => chance_of_rain}]
            }
          ]
        }
      }) do
    {:ok,
     %{
       "chance_of_rain" => string_to_float(chance_of_rain),
       "max_temp" => string_to_float(max_temp),
       "min_temp" => string_to_float(min_temp)
     }}
  end

  def normalize(response) do
    Logger.error("Unexpected weather response: #{inspect(response)}")
    {:error, "Unexpected weather response"}
  end

  defp wwo_api_endpoint() do
    "https://api.worldweatheronline.com/premium/v1/weather.ashx"
  end

  defp wwo_api_params() do
    %{
      q: "#{@location.latitude},#{@location.longitude}",
      key: @appid,
      num_of_days: 1,
      format: "json",
      mca: "no",
      cc: "no",
      tp: 24
    }
  end

  defp fetch_weather_information(endpoint, opts) do
    case Req.get(endpoint, params: opts) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        Logger.info("Weather information fetched successfully:" <> inspect(body))
        {:ok, body}

      {:ok, %Req.Response{status: 404}} ->
        {:error, :not_found}

      {:ok, %Req.Response{status: 400}} ->
        {:error, :not_found}

      {:ok, %Req.Response{status: 401}} ->
        {:error, :api_key_invalid}

      error = {:error, _reason} ->
        error
    end
  end

  defp string_to_float(string_val) do
    case Float.parse(string_val) do
      {float_val, _} -> float_val
      _ -> 0.0
    end
  end
end
