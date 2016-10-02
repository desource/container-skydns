#!/bin/sh
#
# Download and build skydns container
set -euo pipefail

export GOPATH=$PWD/gopath
export PATH=$GOPATH/bin:$PATH

out=$PWD/out

_init() {
  apk add --no-cache git
}

_build() {
  cd $GOPATH/src/github.com/skynetservices/skydns
  go get .
  go build -o ${out}/bin/skydns -v -a -tags netgo --ldflags "-extldflags '-static'"
}

# _dockerfile "version"
_dockerfile() {
  cat <<EOF > ${out}/tag
${1}
EOF

  cat <<EOF > ${out}/Dockerfile
FROM scratch

ADD bin /bin

EXPOSE 53 53/udp

ENTRYPOINT [ "/bin/skydns" ]

EOF
}

_init
_build
_dockerfile 2.5.3a
