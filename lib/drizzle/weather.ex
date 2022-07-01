defmodule Drizzle.Weather do
  @moduledoc """
  This module handles getting the weather forecast.
  """

  @winter_months Application.get_env(:drizzle, :winter_months, [])
  @low_temp 40
  @high_temp 90
  @default_temp 50
  @soil_moisture_sensor Application.get_env(:drizzle, :soil_moisture_sensor, nil)

  @doc """
  weather_adjustment_factor/0 determines adjustments to make to watering time
  based on the atmospheric conditions.
  """
  @spec weather_adjustment_factor() :: float() | {:error, String.t()}
  def weather_adjustment_factor do
    if month_as_atom(DateTime.utc_now().month) in @winter_months do
      0
    else
      {low, high, precipitation} =
        Drizzle.WeatherData.current_state()
        |> Enum.filter(&(!is_nil(&1)))
        |> weather_info()

      temperature_adjustment(low, high)
      |> Kernel.*(precipitation_adjustment(precipitation))
      |> Kernel.*(soil_moisture_adjustment(@soil_moisture_sensor))
    end
  end

  def get_todays_forecast do
    with {:ok, data} <- Drizzle.OWM.query() do
      # retrieving the next 24 hours of weather
      data
      |> temps_and_precips()
      |> Enum.slice(0..23)
      |> Drizzle.WeatherData.update()
    end
  end

  defp temperature_adjustment(low, _high) when low <= @low_temp, do: 0
  defp temperature_adjustment(_low, high) when high >= @high_temp, do: 1.33
  defp temperature_adjustment(_low, _high), do: 1

  # This is the accumulation of rain for 24-36 hours,
  # if we are shooting for 1.5 inches a week that's 38.1 mm
  # with 3 waterings per week that's 12.7 mm per day.
  # We'll start this with if our sum is more than 3mm in
  # 36 hours we stop, 1mm we are at half, else we are full.
  defp precipitation_adjustment(prec) when prec >= 20, do: 0
  defp precipitation_adjustment(prec) when prec >= 10, do: 0.5
  defp precipitation_adjustment(_prec), do: 1

  defp soil_moisture_adjustment(nil), do: 1

  defp soil_moisture_adjustment(%{pin: pin, min: min, max: max}) do
    # check pin for sensor reading.
    moisture = Drizzle.IO.read_soil_moisture(pin)

    # need to calibrate against a non-zero min
    moisture_delta = max - min
    moisture = moisture - min

    case moisture do
      val when val > moisture_delta * 0.9 -> 0.0
      val when val > moisture_delta * 0.85 -> 0.1
      val when val > moisture_delta * 0.8 -> 0.2
      val when val > moisture_delta * 0.75 -> 0.45
      val when val > moisture_delta * 0.7 -> 0.65
      val when val > moisture_delta * 0.65 -> 0.8
      val when val > moisture_delta * 0.6 -> 0.9
      val when val > moisture_delta * 0.55 -> 0.95
      val when val > moisture_delta * 0.5 -> 1.0
      val when val > moisture_delta * 0.45 -> 1.05
      val when val > moisture_delta * 0.4 -> 1.1
      val when val > moisture_delta * 0.35 -> 1.2
      val when val > moisture_delta * 0.3 -> 1.35
      val when val > moisture_delta * 0.85 -> 1.55
      val when val > moisture_delta * 0.2 -> 1.80
      val when val > moisture_delta * 0.85 -> 1.90
      val when val > moisture_delta * 0.1 -> 2.0
      _ -> 2.0
    end
  end

  defp temps_and_precips(data) do
    Enum.map(data["hourly"], fn d ->
      {d["temp"], d["rain"], d["pop"]}
    end)
  end

  # Used when application has just started up
  defp weather_info([]), do: {@default_temp, @default_temp, 0}

  defp weather_info(data) do
    # Coming from OWM, rain parameter is empty unless they
    # are predicting rain. So anything above 0 is planning
    # on rain accumulation.
    with rainfall <-
           Enum.reduce(data, 0, fn {_, am, _pr}, acc ->
             acc + am
           end),
         {low, high} <- Enum.min_max_by(data, fn {temp, _, _} -> temp end) do
      {low_temp, _, _} = low
      {high_temp, _, _} = high
      {low_temp, high_temp, rainfall}
    else
      _err -> {:error, "unknown error"}
    end
  end

  defp month_as_atom(num) do
    months_map = %{
      1 => :jan,
      2 => :feb,
      3 => :mar,
      4 => :apr,
      5 => :may,
      6 => :jun,
      7 => :jul,
      8 => :aug,
      9 => :sep,
      10 => :oct,
      11 => :nov,
      12 => :dec
    }

    Map.get(months_map, num)
  end
end
