# LookupEX

The nEXt generation Discord profile lookup service!

## Setup

If you really want to set this stuff up yourself for some reason, you shpuld do it with Docker and docker-compose.  
You can also do it without, have fun. 😉

*If* you want to set it up using Docker, just use the provided [docker-compose.yml](docker-compose.yml). But before, you might want to change some stuff in there like the used Domains.

To build the needed images, just clone the repository and execute the following on your environment.
```
$ docker-compose build
```

After that, just run the following command and everything should be up. 🤞
```
$ docker-compose up -d
```

## Architecture

### Backend

The main backend serviceconsists of 3 Elixir GenServers:
- The Plug/Cowboy WebServer which handles the web requests
- The Discord service which calls the Discord API to fetch required information
- A Caching service connected to Redis which caches the responses from the Discord API

All reqeusts *(including erroneous ones)* are cached for 10 Minutes to reduce traffic to the Discord API.

This stuff is then wrapped into a Docker container to seamlessly deploy it to a VPS or stuff like that.

Of course, all of that sits comfortly behind a [Traefik](https://doc.traefik.io/traefik/) instance handling CORS and Rate Limiting.

### Frontend

If you are not that kind of *curl*y guy *(haha)*, you can of course use a fancy web frontend which is written in [Svelte](https://svelte.dev). Actually, this was my first attempt to get a deeper look into Sevlte, so please excuse that messy code. :^)

On every commit to the master branch, aa friendly GitHub Actions worker grabs the code, builds the static web app files, deploys them to a branch called `gh-pages` and from there, like the name says, it is served using the GitHub Pages service. I've just set up a CNAME to point [lookup.zekro.de](https://lookup.zekro.de) to the GitHub Pages server.

### CLI

And if you are one of these cool guys 😎 doing everything in terminal land, take a look into the [Releases](https://github.com/zekroTJA/lookupex/releases). There you can find a handy dandy CLI tool, which is [written in Go](cli/) by the way. And it supports colored output! 👀

---

© 2021 Ringo Hoffmann (zekro Development).  
Covered by the MIT License.