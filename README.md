# yt-dlp-docker-script
A script to run yt-dlp in a Docker container.

## Basic usage:
* clone the project with "git clone https://github.com/aljazmc/yt-dlp-docker-script"
* change the directory with "cd yt-dlp-docker-script".
* with "./project.sh start" you download and setup yt-dlp.
* with "./project.sh clean" you clean downloaded docker images.
* download all playlists of YouTube channel/user keeping each playlist in separate directory: 'docker compose run yt-dlp python3 .local/bin/yt-dlp -o "%(uploader)s/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" "https://www.youtube.com/user/TheLinuxFoundation/playlists"'

## Requirements:
* GNU/Linux operating system
* docker with docker compose plugin

LICENSE: [MIT](https://github.com/aljazmc/yt-dlp-docker-script/blob/main/LICENSE)
