#!/bin/sh
#
# Download and build skydns container
set -euo pipefail

export GOPATH=$PWD/go

local src=${GOPATH}/src/github.com/skynetservices/skydns
local out=$PWD/out

_init() {
    apk add --no-cache git
}

_build() {
  cd ${src}
  go get .
  go build -o ${out}/bin/skydns -v -a -tags netgo --ldflags "-extldflags '-static'"
    
  cat <<EOF > ${out}/version
${1}
EOF
}

# _dockerfile "version"
_dockerfile() {
  cat <<EOF > ${out}/Dockerfile
FROM scratch

ADD bin /bin

EXPOSE 53 53/udp

ENTRYPOINT [ "/bin/skydns" ]

EOF
}

_init 
_build $(git -C ${src} describe --tags --dirty)
_dockerfile
