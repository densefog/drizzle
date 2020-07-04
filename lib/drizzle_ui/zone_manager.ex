defmodule DrizzleUi.ZoneManager do
  @moduledoc """
  Manages zones in a map. Zones look like: 

  %{
    "1" => %DrizzleUi.Zone{minutes: 20, zone: "1", atom: :zone1},
    "2" => %DrizzleUi.Zone{minutes: 0, zone: "2", atom: :zone2},
    "3" => %DrizzleUi.Zone{minutes: 0, zone: "3", atom: :zone3},
    "4" => %DrizzleUi.Zone{minutes: 0, zone: "4", atom: :zone4},
    "5" => %DrizzleUi.Zone{minutes: 0, zone: "5", atom: :zone5},
    "6" => %DrizzleUi.Zone{minutes: 0, zone: "6", atom: :zone6},
    "7" => %DrizzleUi.Zone{minutes: 0, zone: "7", atom: :zone7}
  }

  [
    {2255, :on, :zone1},
    {2258, :off, :zone1},
    {2259, :on, :zone2},
    {2302, :off, :zone2},
    {2303, :on, :zone3},
    {2306, :off, :zone3},
    {2307, :on, :zone4},
    {2310, :off, :zone4},
    {2311, :on, :zone5},
    {2314, :off, :zone5},
    {2315, :on, :zone6},
    {2318, :off, :zone6},
    {2319, :on, :zone7},
    {2322, :off, :zone7}
  ]

  [
    {:zone1, :evening, 3},
    {:zone2, :evening, 3},
    {:zone3, :evening, 3},
    {:zone4, :evening, 3},
    {:zone5, :evening, 3},
    {:zone6, :evening, 3},
    {:zone7, :evening, 3}
  ]
  """

  alias DrizzleUi.Zone
  alias Drizzle.IO, as: DrizzleIO

  @zones 1..7 |> Enum.map(&Integer.to_string/1)

  def new_zones() do
    Enum.reduce(@zones, %{}, fn zone_number, acc ->
      Map.put(acc, zone_number, %Zone{
        zone: zone_number,
        atom: String.to_atom("zone#{zone_number}")
      })
    end)
  end

  def update(zones, zone_number, minutes) do
    with zone <- Map.get(zones, zone_number) do
      Map.put(zones, zone_number, %Zone{zone | minutes: minutes})
    end
  end

  def cancel_all(zones) do
    Enum.reduce(zones, %{}, fn {zone_number, %Zone{} = zone}, acc ->
      DrizzleIO.deactivate_zone(zone.atom)

      Map.put(acc, zone_number, %Zone{zone | minutes: 0})
    end)
    |> IO.inspect()
  end

  def set_to_full(zones) do
    Enum.reduce(zones, %{}, fn {zone_number, zone}, acc ->
      Map.put(acc, zone_number, %Zone{zone | minutes: 30})
    end)
  end

  def run_selected(zones) do
    with {:ok, %Zone{} = zone} <- find_zone_running(zones) do
      DrizzleIO.activate_zone_for_time(zone.atom, zone.minutes)
    end

    zones |> IO.inspect(label: "Running zones")
  end

  def get_current_schedule() do
    case Drizzle.TodaysEvents.current_state() do
      nil -> []
      state -> state
    end
  end

  defp find_zone_running(zones) do
    zones
    |> Enum.find(fn {_x, %Zone{minutes: minutes}} -> minutes > 0 end)
    |> case do
      {_, %Zone{} = zone} ->
        {:ok, zone}

      _ ->
        {:error, "No zone found"}
    end
  end
end
