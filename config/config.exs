import Config

config :logger, :console,
  format: "$date $time [$level]$levelpad $message $metadata\n",
  metadata: [:id]
