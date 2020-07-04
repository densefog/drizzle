use Mix.Config

# config :drizzle, gpio_module: Drizzle.GPIO
config :drizzle, gpio_module: Circuits.GPIO

config :drizzle, DrizzleUiWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
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
    # morning: {500, 700},
    evening: {2255, 2359}
  },
  # schedule is defined as {zone, watering_time_key, duration_in_minutes}
  schedule: %{
    sun: [
      # {:zone1, :morning, 5},
      # {:zone2, :morning, 5},
      {:zone1, :evening, 3},
      {:zone2, :evening, 3},
      {:zone3, :evening, 3},
      {:zone4, :evening, 3},
      {:zone5, :evening, 3},
      {:zone6, :evening, 3},
      {:zone7, :evening, 3}
    ],
    mon: [
      {:zone1, :evening, 3},
      {:zone2, :evening, 3},
      {:zone3, :evening, 3},
      {:zone4, :evening, 3},
      {:zone5, :evening, 3},
      {:zone6, :evening, 3},
      {:zone7, :evening, 3}
    ],
    tue: [
      {:zone1, :evening, 3},
      {:zone2, :evening, 3},
      {:zone3, :evening, 3},
      {:zone4, :evening, 3},
      {:zone5, :evening, 3},
      {:zone6, :evening, 3},
      {:zone7, :evening, 3}
    ],
    wed: [
      {:zone1, :evening, 3},
      {:zone2, :evening, 3},
      {:zone3, :evening, 3},
      {:zone4, :evening, 3},
      {:zone5, :evening, 3},
      {:zone6, :evening, 3},
      {:zone7, :evening, 3}
    ],
    thu: [
      {:zone1, :evening, 3},
      {:zone2, :evening, 3},
      {:zone3, :evening, 3},
      {:zone4, :evening, 3},
      {:zone5, :evening, 3},
      {:zone6, :evening, 3},
      {:zone7, :evening, 3}
    ],
    fri: [
      {:zone1, :evening, 3},
      {:zone2, :evening, 3},
      {:zone3, :evening, 3},
      {:zone4, :evening, 3},
      {:zone5, :evening, 3},
      {:zone6, :evening, 3},
      {:zone7, :evening, 3}
    ],
    sat: [
      {:zone1, :evening, 3},
      {:zone2, :evening, 3},
      {:zone3, :evening, 3},
      {:zone4, :evening, 3},
      {:zone5, :evening, 3},
      {:zone6, :evening, 3},
      {:zone7, :evening, 3}
    ]
  }

# Watch static and templates for browser reloading.
config :drizzle, DrizzleUiWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/drizzle_ui_web/(live|views)/.*(ex)$",
      ~r"lib/drizzle_ui_web/templates/.*(eex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
