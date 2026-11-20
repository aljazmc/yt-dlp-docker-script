#!/bin/bash
#
# "./project.sh start" writes a Dockerfile and a docker-compose.yml that runs
# as your user, then installs yt-dlp in the container. Runs on a copy of
# project.sh in a temporary folder, with docker replaced by a stand-in that
# records its calls, so nothing is built, pulled or downloaded.
#
# Run from anywhere: bash tests/test_project.sh

repo=$(cd "$(dirname "$0")/.." && pwd) || exit 1
tmp=$(mktemp -d) || exit 1
trap 'rm -rf "$tmp"' EXIT

mkdir "$tmp/bin" "$tmp/work"
cat > "$tmp/bin/docker" <<EOF
#!/bin/sh
[ "\$1 \$2" = "compose version" ] && exit 0
echo "docker \$*" >> "$tmp/calls"
EOF
chmod +x "$tmp/bin/docker"
cp "$repo/project.sh" "$tmp/work/project.sh"

(cd "$tmp/work" && PATH="$tmp/bin:$PATH" bash project.sh start) > "$tmp/log" 2>&1
code=$?

failures=0

expect() {

    if eval "$2"; then
        echo "ok: $1"
    else
        echo "FAIL: $1" >&2
        failures=$((failures + 1))
    fi

}

work="$tmp/work"
expect "start exits with 0" "[ $code -eq 0 ]"
expect "writes a Dockerfile from debian" "grep -q '^FROM debian' '$work/Dockerfile'"
expect "the image runs as $USER" "grep -q '^USER $USER$' '$work/Dockerfile'"
expect "compose runs the service as your UID and GID" \
    "grep -q 'user: $(id -u):$(id -g)' '$work/docker-compose.yml'"
expect "installs yt-dlp with pip" \
    "grep -q 'docker compose run --rm yt-dlp pip3 install .* yt-dlp' '$tmp/calls'"
expect "runs docker compose three times" "[ \$(wc -l < '$tmp/calls') -eq 3 ]"

if [ "$failures" -gt 0 ]; then
    echo "FAILED: $failures" >&2
    cat "$tmp/log" >&2
    exit 1
fi
echo "PASS"
