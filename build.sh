#!/usr/bin/env sh
set -eux

export GOPATH=$PWD/gopath
export PATH=$GOPATH/bin:$PATH

OUT=$PWD/skydns-build


cd $GOPATH/src/github.com/skynetservices/skydns

go get .

go build -v -a -tags netgo --ldflags "-extldflags '-static'"

mkdir -p $OUT
cp $GOPATH/bin/skydns $OUT/

cat <<EOF > $OUT/Dockerfile
FROM scratch

ADD skydns /bin/skydns

EXPOSE 53 53/udp

ENTRYPOINT [ "/bin/skydns" ]

EOF
