[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

# yt-dlp-docker-script

A script to run [yt-dlp](https://github.com/yt-dlp/yt-dlp) in a Docker container.

## > Prerequisites

* Linux system with bash shell
* Docker (with docker compose plugin) installed and running

## > Installation

1. clone the project directory,
```
git clone https://github.com/aljazmc/yt-dlp-docker-script
```

2. move to the project folder
```
cd yt-dlp-docker-script
```

3. run `./project.sh start` to install yt-dlp.
```
./project.sh start
```

## > Download example

- Download all playlists of YouTube channel/user keeping each playlist in separate directory:
```
$ docker compose run yt-dlp python3 .local/bin/yt-dlp --sleep-requests 5 --sleep-interval 20 --max-sleep-interval 30 -o "%(uploader)s/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" "https://www.youtube.com/user/TheLinuxFoundation/playlists"
```

## > Cleanup

- after use you might want to remove docker images and cached files with:
```
./project.sh clean
```
