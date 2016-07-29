#!/usr/bin/env sh
set -eux

apk add --no-cache git

export GOPATH=$PWD/gopath
export PATH=$GOPATH/bin:$PATH

OUT=$PWD/skydns-build

cd $GOPATH/src/github.com/skynetservices/skydns

go get .

mkdir -p $OUT/bin
go build -o $OUT/bin/skydns -v -a -tags netgo --ldflags "-extldflags '-static'"

cat <<EOF > $OUT/Dockerfile
FROM scratch

ADD bin /bin

EXPOSE 53 53/udp

ENTRYPOINT [ "/bin/skydns" ]

EOF
