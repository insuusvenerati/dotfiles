#!/bin/sh
set -e
DOWNLOAD_URL="https://github.com/getantibody/antibody/releases/download"
test -z "$TMPDIR" && TMPDIR="$(mktemp -d)"

last_version() {
  curl -s https://raw.githubusercontent.com/getantibody/homebrew-tap/master/Formula/antibody.rb |
    grep url |
    cut -f8 -d'/'
}

download() {
  version="$(last_version)" || true
  test -z "$version" && {
    echo "Unable to get antibody version."
    exit 1
  }
  echo "Downloading antibody $version for $(uname -s)_$(uname -m)..."
  rm -f /tmp/antibody.tar.gz
  wget -O /tmp/antibody.tar.gz \
    "https://github.com/getantibody/antibody/releases/download/v4.1.1/antibody_Linux_armv7.tar.gz"
}

extract() {
  tar -xf /tmp/antibody.tar.gz -C "$TMPDIR"
}

download
extract || true
sudo mv -f "$TMPDIR"/antibody /usr/local/bin/antibody
which antibody
