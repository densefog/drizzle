defmodule DrizzleUiWeb.ThermostatLive do
  use DrizzleUiWeb, :live_view

  alias DrizzleUi.ZoneManager

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(zones: ZoneManager.new_zones())
      |> assign(schedule: ZoneManager.get_current_schedule())

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

    params |> IO.inspect(label: "params")
    minutes = String.to_integer(Map.get(params, zone_number_str)) |> IO.inspect(label: "minutes")
    "zone_" <> zone_number = zone_number_str
    socket = update(socket, :zones, &ZoneManager.update(&1, zone_number, minutes))

    {:noreply, socket}
  end

  def handle_event("validate", params, socket) do
    params |> IO.inspect()
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

    {:noreply, socket}
  end
end
