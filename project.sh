#!/bin/bash

## Check if docker compose is installed or quit

if [[ ! -x "$(command -v compose version)" ]]; then
    echo "Compose plugin is not installed. Exiting..."
    exit
fi

## Variables

PROJECT_UID=$(id -u)
PROJECT_GID=$(id -g)

## Functions

clean() {

    docker compose down -v --rmi all --remove-orphans
    find . -mindepth 1 -maxdepth 1 -type f \
    | sed "
        /.git/d;
	/.gitignore/d;
	/LICENSE/d;
	/README.md/d;
	/cookies.txt/d;
	/command.sh/d;
	/project.sh/d" \
    | xargs -I {} rm -rf {} \
    | rm -rf .cache .local

}

start() {

mkdir -p .local .cache/pip .cache/yt-dlp/youtube-nsig
  
if [[ ! -f Dockerfile ]]; then
    touch Dockerfile
    cat <<EOF> Dockerfile
FROM debian:latest

ENV LANG C.UTF-8

# runtime dependencies
RUN set -eux && \
    apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    libbluetooth-dev \
    tk-dev \
    python3.13 \
    python3-pip \
    sudo \
    uuid-dev && rm -rf /var/lib/apt/lists/*

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

CMD ["python3"]
EOF
fi

if [[ ! -f docker-compose.yml ]]; then
  cat<<EOF > docker-compose.yml
services:
    yt-dlp:
        build: .
        working_dir: /home/$USER
        volumes:
            - .:/home/$USER
            - .local:/.local
            - .cache/pip:/.cache/pip
        environment:
            PATH:     "/.local/bin:/home/$USER/.local/bin:\$PATH"
EOF

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "Adding user configuration line to docker-compose.yml for GNU/Linux users."
        sed -i "/working_dir\:/{s@^\( \+\)@\1user\: $PROJECT_UID\:$PROJECT_GID\n\1@}" docker-compose.yml
    fi

fi

docker compose run --rm yt-dlp pip3 install --break-system-packages --user yt-dlp
docker compose run --rm yt-dlp python3 .local/bin/yt-dlp --version
docker compose run --rm yt-dlp sh -c "printenv"

}

"$1"
