# yt-dlp-docker-script
A script to run yt-dlp in a Docker container.

## > Requirements:

* GNU/Linux operating system
* docker with docker compose plugin

## > Basic usage:

* clone the project with `git clone https://github.com/aljazmc/yt-dlp-docker-script`
* move into the directory with `cd yt-dlp-docker-script`
* with `./project.sh start` you download and setup yt-dlp
* with `./project.sh clean` you clean downloaded docker images

## > Command examples adapted from [yt-dlp](https://github.com/yt-dlp/yt-dlp) github account:
```
$ docker compose run yt-dlp python3 .local/bin/yt-dlp --print filename -o "test video.%(ext)s" BaW_jenozKc
test video.webm    # Literal name with correct extension

$ docker compose run yt-dlp python3 .local/bin/yt-dlp --print filename -o "%(title)s.%(ext)s" BaW_jenozKc
youtube-dl test video ''_ä↭𝕐.webm    # All kinds of weird characters

$ docker compose run yt-dlp python3 .local/bin/yt-dlp --print filename -o "%(title)s.%(ext)s" BaW_jenozKc --restrict-filenames
youtube-dl_test_video_.webm    # Restricted file name

# Download YouTube playlist videos in separate directory indexed by video order in a playlist
$ docker compose run yt-dlp python3 .local/bin/yt-dlp -o "%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" "https://www.youtube.com/playlist?list=PLwiyx1dc3P2JR9N8gQaQN_BCvlSlap7re"

# Download YouTube playlist videos in separate directories according to their uploaded year
$ docker compose run yt-dlp python3 .local/bin/yt-dlp -o "%(upload_date>%Y)s/%(title)s.%(ext)s" "https://www.youtube.com/playlist?list=PLwiyx1dc3P2JR9N8gQaQN_BCvlSlap7re"

# Prefix playlist index with " - " separator, but only if it is available
$ docker compose run yt-dlp python3 .local/bin/yt-dlp -o "%(playlist_index&{} - |)s%(title)s.%(ext)s" BaW_jenozKc "https://www.youtube.com/user/TheLinuxFoundation/playlists"

# Download all playlists of YouTube channel/user keeping each playlist in separate directory:
$ docker compose run yt-dlp python3 .local/bin/yt-dlp -o "%(uploader)s/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" "https://www.youtube.com/user/TheLinuxFoundation/playlists"

# Download Udemy course keeping each chapter in separate directory under MyVideos directory in your home
$ docker compose run yt-dlp python3 .local/bin/yt-dlp -u user -p password -P "~/MyVideos" -o "%(playlist)s/%(chapter_number)s - %(chapter)s/%(title)s.%(ext)s" "https://www.udemy.com/java-tutorial"

# Download entire series season keeping each series and each season in separate directory under C:/MyVideos
$ docker compose run yt-dlp python3 .local/bin/yt-dlp -P "C:/MyVideos" -o "%(series)s/%(season_number)s - %(season)s/%(episode_number)s - %(episode)s.%(ext)s" "https://videomore.ru/kino_v_detalayah/5_sezon/367617"

# Download video as "C:\MyVideos\uploader\title.ext", subtitles as "C:\MyVideos\subs\uploader\title.ext"
# and put all temporary files in "C:\MyVideos\tmp"
$ docker compose run yt-dlp python3 .local/bin/yt-dlp -P "C:/MyVideos" -P "temp:tmp" -P "subtitle:subs" -o "%(uploader)s/%(title)s.%(ext)s" BaW_jenoz --write-subs

# Download video as "C:\MyVideos\uploader\title.ext" and subtitles as "C:\MyVideos\uploader\subs\title.ext"
$ docker compose run yt-dlp python3 .local/bin/yt-dlp -P "C:/MyVideos" -o "%(uploader)s/%(title)s.%(ext)s" -o "subtitle:%(uploader)s/subs/%(title)s.%(ext)s" BaW_jenozKc --write-subs

# Stream the video being downloaded to stdout
$ docker compose run yt-dlp python3 .local/bin/yt-dlp -o - BaW_jenozKc
```

## > LICENSE: [MIT](https://github.com/aljazmc/yt-dlp-docker-script/blob/main/LICENSE)
