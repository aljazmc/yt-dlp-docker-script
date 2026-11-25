# yt-dlp-docker-script

[![CI](https://github.com/aljazmc/yt-dlp-docker-script/actions/workflows/ci.yml/badge.svg)](https://github.com/aljazmc/yt-dlp-docker-script/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![yt-dlp](https://img.shields.io/badge/yt--dlp-latest-ff0000?logo=youtube&logoColor=white)](https://github.com/yt-dlp/yt-dlp)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ed?logo=docker&logoColor=white)](https://docs.docker.com/compose/)
[![FFmpeg](https://img.shields.io/badge/FFmpeg-included-007808?logo=ffmpeg&logoColor=white)](https://ffmpeg.org/)
[![Bash](https://img.shields.io/badge/Bash-project.sh-4eaa25?logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![ShellCheck](https://img.shields.io/badge/ShellCheck-checked-4eaa25?logo=gnubash&logoColor=white)](https://www.shellcheck.net/)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-fe5196?logo=conventionalcommits&logoColor=white)](https://www.conventionalcommits.org/)

The easiest way to run [yt-dlp](https://github.com/yt-dlp/yt-dlp) in Docker.
A single `project.sh` script generates a `Dockerfile` and
`docker-compose.yml`, builds a Debian image with `python3` and `ffmpeg`, and
installs yt-dlp into the project folder. The container runs as your own user
(same UID/GID), so downloaded files are owned by you.

## Features

- **Nothing on the host but Docker.** Python, FFmpeg and yt-dlp live in the
  image and the project folder.
- **Your files.** The container runs with your user and group id, so every
  download belongs to you.
- **Always current.** `./project.sh update` upgrades yt-dlp, which keeps up
  with the sites that change most often.
- **Audio extraction included.** FFmpeg is in the image, for MP3 and other
  audio formats.

## Quick start

```sh
git clone https://github.com/aljazmc/yt-dlp-docker-script
cd yt-dlp-docker-script
./project.sh start
docker compose run --rm yt-dlp python3 .local/bin/yt-dlp "https://www.youtube.com/watch?v=VIDEO_ID"
```

`./project.sh start` will:

1. create the `.local` and `.cache` directories,
2. generate `Dockerfile` and `docker-compose.yml` (only if they don't
   already exist),
3. build the image and install yt-dlp with pip into `.local`,
4. print the installed yt-dlp version to confirm it works.

## Requirements

| Requirement | Notes |
| --- | --- |
| Linux with bash | |
| Docker | with the [Compose plugin](https://docs.docker.com/compose/install/linux/) (`docker compose`), installed and running |

## Usage

Run yt-dlp through Docker Compose from the project folder:

```sh
docker compose run --rm yt-dlp python3 .local/bin/yt-dlp [OPTIONS] URL
```

The project folder is mounted as the container's working directory, so
**downloads are saved into the project folder** on your host.

### Examples

Download a single video:

```sh
docker compose run --rm yt-dlp python3 .local/bin/yt-dlp "https://www.youtube.com/watch?v=VIDEO_ID"
```

Extract audio only as MP3 (FFmpeg is included in the image):

```sh
docker compose run --rm yt-dlp python3 .local/bin/yt-dlp -x --audio-format mp3 "https://www.youtube.com/watch?v=VIDEO_ID"
```

Download all playlists of a YouTube channel, keeping each playlist in its own
directory and pausing between requests to avoid rate limiting:

```sh
docker compose run --rm yt-dlp python3 .local/bin/yt-dlp \
    --sleep-requests 5 --sleep-interval 20 --max-sleep-interval 30 \
    -o "%(uploader)s/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" \
    "https://www.youtube.com/user/TheLinuxFoundation/playlists"
```

## Updating yt-dlp

Sites change often, so keep yt-dlp up to date:

```sh
./project.sh update
```

## Cleanup

Remove the Docker containers, images and volumes, the generated files and
the cached and installed packages:

```sh
./project.sh clean
```

> [!CAUTION]
> This keeps `cookies.txt`, `command.sh` and the repository files, but **it
> also deletes any other files in the top level of the project folder**. Move
> your downloads somewhere else before running it.

## Tests

```sh
bash tests/test_project.sh
shellcheck project.sh tests/*.sh
```

`tests/test_project.sh` checks that `./project.sh start` writes a
`Dockerfile` and a `docker-compose.yml` that runs as your user, then installs
yt-dlp in the container. It runs on a copy of `project.sh` in a temporary
folder, with `docker` replaced by a stand-in that records its calls, so
nothing is built, pulled or downloaded. The
[lint](.github/workflows/lint.yml) workflow runs ShellCheck on every push and
pull request.

## License

The script is licensed under the [MIT License](LICENSE). yt-dlp is released
into the public domain under the
[Unlicense](https://github.com/yt-dlp/yt-dlp/blob/master/LICENSE), and FFmpeg
under the GNU LGPL or GPL, depending on how it was built. What you download
is subject to the terms of the site it comes from.
