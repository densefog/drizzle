use Mix.Config

# config :drizzle, gpio_module: Drizzle.GPIO
config :drizzle, gpio_module: Circuits.GPIO

config :drizzle, DrizzleUiWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: false,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

config :drizzle,
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

# Watch static and templates for browser reloading.
# config :drizzle, DrizzleUiWeb.Endpoint,
# live_reload: [
# patterns: [
# ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
# ~r"priv/gettext/.*(po)$",
# ~r"lib/drizzle_ui_web/(live|views)/.*(ex)$",
# ~r"lib/drizzle_ui_web/templates/.*(eex)$"
# ]
# ]

# Do not include metadata nor timestamps in development logs
# All logs going to ringlogger
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
