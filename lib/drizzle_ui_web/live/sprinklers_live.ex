defmodule DrizzleUiWeb.SprinklersLive do
  use DrizzleUiWeb, :live_view

  alias DrizzleUi.ZoneManager

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(zones: ZoneManager.new_zones())
      |> assign(schedule: ZoneManager.get_current_schedule())
      |> assign(weather: get_weather())
      |> assign(weather_adjustment_factor: Drizzle.Weather.weather_adjustment_factor())

    :timer.send_interval(30000, self(), :update)

    {:ok, socket}
  end

  def handle_event("validate", %{"_target" => [zone_number_str]} = params, socket) do
    # %{
    # "_target" => ["zone", "3"],
    # "zone" => %{
    # "1" => "25",
    # "2" => "20",
    # "3" => "30",
    # "4" => "0",
    # "5" => "0",
    # "6" => "0",
    # "7" => "0"
    # }
    # }

    minutes = String.to_integer(Map.get(params, zone_number_str))
    "zone_" <> zone_number = zone_number_str
    socket = update(socket, :zones, &ZoneManager.update(&1, zone_number, minutes))

    {:noreply, socket}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("cancel_all", _value, socket) do
    socket =
      socket
      |> update(:zones, &ZoneManager.cancel_all/1)
      |> assign(schedule: ZoneManager.get_current_schedule())

    {:noreply, socket}
  end

  def handle_event("set_to_full", _value, socket) do
    socket = put_flash(socket, :info, "Schedule being reset, please wait...")
    socket = update(socket, :zones, &ZoneManager.set_to_full/1)

    {:noreply, socket}
  end

  def handle_event("run_selected", _value, socket) do
    socket = update(socket, :zones, &ZoneManager.run_selected/1)
    {:noreply, socket}
  end

  def handle_info(:update, socket) do
    socket =
      socket
      |> assign(schedule: ZoneManager.get_current_schedule())
      |> assign(weather: get_weather())
      |> assign(weather_adjustment_factor: Drizzle.Weather.weather_adjustment_factor())

    {:noreply, socket}
  end

  defp get_weather() do
    {low, high, precip} = Drizzle.WeatherData.current_state()
    %{low: low, high: high, precip: precip}
  end
end
