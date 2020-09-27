#!/usr/bin/bash -e

echo "Generating root CA key..."
openssl genrsa -des3 -out rootCA.key 4096
echo ""

echo "Generating root CA cert..."
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.crt
echo ""

echo "Generating altnames.txt..."
echo "subjectAltName = DNS:*.fabiancsalad.com, DNS:fabiancsalad.com, DNS:fabiancsalad" > altnames.txt 
echo ""

echo "Generating certificate signing request for your domain..."
openssl req -out sslcert.csr -newkey rsa:2048 -nodes -keyout private.key -config san.cnf
echo ""

echo "Verifying DNS names in CSR file..."
openssl req -noout -text -in sslcert.csr | grep DNS
echo ""

echo "Self sigining the sertificate..."
openssl x509 -req -in sslcert.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out fabiancsalad.crt -days 500 -sha256 -extfile altnames.txt
echo ""
