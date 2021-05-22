# Drizzle

To get running:

1. git clone repo
2. Copy host.sh.example and rpi3.sh.example to host.sh and rpi3.sh
3. Depending on if deploying to hardware or running local, run `source host.sh` or `source rpi3.sh`
4. Run `mix deps.get`
5. cd into 'assets' folder and run (from phoenix):
   `npm install && node node_modules/webpack/bin/webpack.js --mode development`
6. cd back to root and run `iex -S mix phx.server` to run locally
7. To deploy run `mix firmware` (and `mix firmware.burn` if writing to sd card)
8. Run `./upload.sh` to send to running hardware.

## Learn more

- Official docs: https://hexdocs.pm/nerves/getting-started.html
- Official website: https://nerves-project.org/
- Forum: https://elixirforum.com/c/nerves-forum
- Discussion Slack elixir-lang #nerves ([Invite](https://elixir-slackin.herokuapp.com/))
- Source: https://github.com/nerves-project/nerves

# To Connect remotely

- ssh nerves.local
