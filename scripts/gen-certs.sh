#!/bin/bash
set -e

OUT=secrets

# CA
openssl genrsa -out $OUT/ca.key 4096
openssl req -new -x509 -days 3650 -key $OUT/ca.key \
  -subj "/CN=mqtt-ca" \
  -out $OUT/ca.crt \
  -addext "basicConstraints=critical,CA:TRUE" \
  -addext "keyUsage=critical,keyCertSign,cRLSign" \
  -addext "subjectKeyIdentifier=hash"

# Server cert (broker) - SAN must include the Docker service hostname
openssl genrsa -out $OUT/server.key 2048
openssl req -new -key $OUT/server.key \
  -subj "/CN=broker" \
  -out $OUT/server.csr
openssl x509 -req -in $OUT/server.csr -CA $OUT/ca.crt -CAkey $OUT/ca.key \
  -CAcreateserial -out $OUT/server.crt -days 3650 \
  -extfile <(printf "subjectAltName=DNS:broker,DNS:localhost,IP:127.0.0.1")

# Client cert (Go web app)
openssl genrsa -out $OUT/web.key 2048
openssl req -new -key $OUT/web.key \
  -subj "/CN=go-api" \
  -out $OUT/web.csr
openssl x509 -req -in $OUT/web.csr -CA $OUT/ca.crt -CAkey $OUT/ca.key \
  -CAcreateserial -out $OUT/web.crt -days 3650 \
  -extfile <(printf "subjectAltName=DNS:go-api,DNS:localhost")

rm -f $OUT/server.csr $OUT/web.csr
echo "Done. Certificates written to $OUT/"
