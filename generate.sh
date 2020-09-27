#!/usr/bin/bash -eux

# generate root CA key
openssl genrsa -des3 -out rootCA.key 4096

# generate root CA cert
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.crt

# generate certificate request for a domain
openssl req -out sslcert.csr -newkey rsa:2048 -nodes -keyout private.key

# verify request content
ls -la
openssl req -noout -text -in sslcert.csr | grep DNS

# generate altnames.txt
echo "subjectAltName = DNS:*.fabiancsalad.com, DNS:fabiancsalad.com, DNS:fabiancsalad" > altnames.txt 

# self sign the csr
openssl x509 -req -in sslcert.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out fabiancsalad.crt -days 500 -sha256 -extfile altnames.txt
