# LookupEX

The nEXt generation Discord profile lookup service!

## Architecture

#### Backend

The main backend serviceconsists of 3 Elixir GenServers:
- The Plug/Cowboy WebServer which handles the web requests
- The Discord service which calls the Discord API to fetch required information
- A Caching service connected to Redis which caches the responses from the Discord API

All reqeusts *(including erroneous ones)* are cached for 10 Minutes to reduce traffic to the Discord API.

This stuff is then wrapped into a Docker container to seamlessly deploy it to a VPS or stuff like that.

Of course, all of that sits comfortly behind a [Traefik](https://doc.traefik.io/traefik/) instance handling CORS and Rate Limiting.

#### Frontend

If you are not that kind of *curl*y guy (haha), you can of course use a fancy web frontend which is written in [Svelte](https://svelte.dev). Actually, this was my first attempt to get a deeper look into Sevlte, so please excuse that messy code. :^)

On every commit to the master branch, aa friendly GitHub Actions worker grabs the code, builds the static web app files, deploys them to a branch called `gh-pages` and from there, like the name says, it is served using the GitHub Pages service. I've just set up a CNAME to point [lookup.zekro.de](https://lookup.zekro.de) to the GitHub Pages server.