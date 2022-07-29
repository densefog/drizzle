# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

# Enable the Nerves integration with Mix
Application.start(:nerves_bootstrap)

config :drizzle, target: Mix.target()

config :drizzle,
  location: %{latitude: System.get_env("LATITUDE"), longitude: System.get_env("LONGITUDE")},
  appid: System.get_env("OWM_API_KEY"),
  utc_offset: -4,
  winter_months: [:jan, :feb, :mar, :apr, :oct, :nov, :dec],
  # winter_months: [],
  soil_moisture_sensor: nil,
  # soil_moisture_sensor: %{pin: 26, min: 0, max: 539},
  zone_pins: %{
    zone1: 4,
    zone2: 17,
    zone3: 27,
    zone4: 22,
    zone5: 18,
    zone6: 23,
    zone7: 24,
    zone8: 14
  },
  # watering times are defined as key {start_time, end_time}
  available_watering_times: %{
    morning: {800, 1100},
    evening: {2030, 2359}
  },
  # schedule is defined as {zone, watering_time_key, duration_in_minutes}
  schedule: %{
    sun: [
      {:zone1, :evening, 30},
      {:zone2, :evening, 30},
      {:zone3, :evening, 30},
      {:zone4, :evening, 20},
      {:zone5, :morning, 30},
      {:zone6, :morning, 20},
      {:zone7, :morning, 30}
    ],
    mon: [
      {:zone1, :evening, 30},
      {:zone2, :evening, 30},
      {:zone3, :evening, 30},
      {:zone4, :evening, 20},
      {:zone5, :morning, 30},
      {:zone6, :morning, 20},
      {:zone7, :morning, 30}
    ],
    tue: [
      {:zone1, :evening, 30},
      {:zone2, :evening, 30},
      {:zone3, :evening, 30},
      {:zone4, :evening, 20},
      {:zone5, :morning, 30},
      {:zone6, :morning, 20},
      {:zone7, :morning, 30}
    ],
    wed: [
      {:zone1, :evening, 30},
      {:zone2, :evening, 30},
      {:zone3, :evening, 30},
      {:zone4, :evening, 20},
      {:zone5, :morning, 30},
      {:zone6, :morning, 20},
      {:zone7, :morning, 30}
    ],
    thu: [
      {:zone1, :evening, 30},
      {:zone2, :evening, 30},
      {:zone3, :evening, 30},
      {:zone4, :evening, 20},
      {:zone5, :morning, 30},
      {:zone6, :morning, 20},
      {:zone7, :morning, 30}
    ],
    fri: [
      {:zone1, :evening, 30},
      {:zone2, :evening, 30},
      {:zone3, :evening, 30},
      {:zone4, :evening, 20},
      {:zone5, :morning, 30},
      {:zone6, :morning, 20},
      {:zone7, :morning, 30}
    ],
    sat: [
      {:zone1, :evening, 30},
      {:zone2, :evening, 30},
      {:zone3, :evening, 30},
      {:zone4, :evening, 20},
      {:zone5, :morning, 30},
      {:zone6, :morning, 20},
      {:zone7, :morning, 30}
    ]
  }

config :drizzle, DrizzleUiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1+7mUZv0H8etfLTLvmAoXzeb3gLumACeobVDPgjALyC3nxd6NOsGkdGDkhGttsXH",
  render_errors: [view: DrizzleUiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: DrizzleUi.PubSub,
  live_view: [signing_salt: "zBVPFycz"],
  server: true

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# Customize non-Elixir parts of the firmware.  See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.
config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Set the SOURCE_DATE_EPOCH date for reproducible builds.
# See https://reproducible-builds.org/docs/source-date-epoch/ for more information

config :nerves, source_date_epoch: "1585789427"

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger]

if Mix.target() != :host do
  import_config "target.exs"
end

import_config "#{Mix.target()}.exs"
