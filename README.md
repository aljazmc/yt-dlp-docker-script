[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

# yt-dlp-docker-script

Run [yt-dlp](https://github.com/yt-dlp/yt-dlp) inside a Docker container without installing Python, pip or ffmpeg on your host.

A single `project.sh` script generates a `Dockerfile` and `docker-compose.yml`, builds a Debian image with `python3` and `ffmpeg`, and installs yt-dlp into the project folder. The container runs as your own user (same UID/GID), so downloaded files are owned by you, not by root.

## Prerequisites

* Linux with a bash shell
* Docker with the [Compose plugin](https://docs.docker.com/compose/install/linux/) (`docker compose`), installed and running

## Installation

```bash
git clone https://github.com/aljazmc/yt-dlp-docker-script
cd yt-dlp-docker-script
./project.sh start
```

`./project.sh start` will:

1. create the `.local` and `.cache` directories,
2. generate `Dockerfile` and `docker-compose.yml` (only if they don't already exist),
3. build the image and install yt-dlp with pip into `.local`,
4. print the installed yt-dlp version to confirm it works.

## Usage

Run yt-dlp through Docker Compose from the project folder:

```bash
docker compose run --rm yt-dlp python3 .local/bin/yt-dlp [OPTIONS] URL
```

The project folder is mounted as the container's working directory, so **downloads are saved into the project folder** on your host.

### Examples

Download a single video:

```bash
docker compose run --rm yt-dlp python3 .local/bin/yt-dlp "https://www.youtube.com/watch?v=VIDEO_ID"
```

Extract audio only as MP3 (ffmpeg is included in the image):

```bash
docker compose run --rm yt-dlp python3 .local/bin/yt-dlp -x --audio-format mp3 "https://www.youtube.com/watch?v=VIDEO_ID"
```

Download all playlists of a YouTube channel, keeping each playlist in its own directory and pausing between requests to avoid rate limiting:

```bash
docker compose run --rm yt-dlp python3 .local/bin/yt-dlp \
    --sleep-requests 5 --sleep-interval 20 --max-sleep-interval 30 \
    -o "%(uploader)s/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" \
    "https://www.youtube.com/user/TheLinuxFoundation/playlists"
```

### Using cookies

For content that requires being signed in, export your browser cookies in Netscape format to `cookies.txt` in the project folder and pass it to yt-dlp:

```bash
docker compose run --rm yt-dlp python3 .local/bin/yt-dlp --cookies cookies.txt "URL"
```

`cookies.txt` is ignored by git and kept by `./project.sh clean`. Keep it private, since it gives access to your account.

## Updating yt-dlp

Sites change often, so keep yt-dlp up to date:

```bash
docker compose run --rm yt-dlp pip3 install --break-system-packages --user -U yt-dlp
```

## Cleanup

Remove the Docker containers, images and volumes, the generated files and the cached/installed packages:

```bash
./project.sh clean
```

This keeps `cookies.txt`, `command.sh` and the repository files, but **it also deletes any other files in the top level of the project folder**. Move your downloads somewhere else before running it.
