#!/bin/bash

## Variables

PROJECT_UID=`id -u`
PROJECT_GID=`id -g`

## Checks if OS is linux and docker compose is installed

if ! (( "$OSTYPE" == "gnu-linux" )); then
  echo "script runs only on GNU/Linux OS. Exiting..."
  exit
fi

if [[ ! -x "$(command -v compose version)" ]]; then
  echo "Compose plugin is not installed. Exiting..."
  exit
fi

## Functions

clean() {

  docker compose down -v --rmi all --remove-orphans
  rm -rf \
    .local \
    .cache \
    docker-compose.yml \
    Dockerfile
    
}

start() {

mkdir -p .local .cache/pip .cache/yt-dlp/youtube-nsig

  if [[ ! -f Dockerfile ]]; then
    touch Dockerfile && \
    cat <<EOF> Dockerfile
  FROM python:latest

  ENV DEBIAN_FRONTEND=noninteractive
  ENV USER=$USER

  RUN dpkg apt-get update && \
    apt-get install -y \
    ffmpeg \
    libav-tools

  ENV LC_ALL $PROJECT_LANG
  ENV LANG $PROJECT_LANG
  ENV LANGUAGE $PROJECT_LANG

  RUN groupadd -g $PROJECT_GID -r $USER
  RUN useradd -u $PROJECT_UID -g $PROJECT_GID --create-home -r $USER

  #Change password
  RUN echo "$USER:$USER" | chpasswd
  #Make sudo passwordless
  RUN echo "$USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-$USER
  RUN usermod -aG sudo $USER
  RUN usermod -aG plugdev $USER

  USER $USER

  WORKDIR /home/$USER
EOF
fi

if [[ ! -f docker-compose.yml ]]; then
  cat<<EOF > docker-compose.yml
services:
  yt-dlp:
    build: .
    image: python:latest
    user: $PROJECT_UID:$PROJECT_GID
    working_dir: /home/$USER
    volumes:
      - .:/home/$USER
      - .local:/.local
      - .cache/pip:/.cache/pip
    environment:
      PATH:     "/.local/bin:\$PATH"
EOF
fi

docker compose run yt-dlp pip3 install --user yt-dlp
docker compose run yt-dlp python3 .local/bin/yt-dlp --version

}

"$1"
