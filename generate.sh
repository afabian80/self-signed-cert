#!/usr/bin/bash -e

ROOT_CA_KEY='rootCA.key'
ROOT_CA_CRT='rootCA.crt'
DOMAIN_CSR='sslcert.csr'
DOMAIN_KEY='private.key'
DOMAIN_CRT='acmex.crt'

echo "Generating root CA key..."
openssl genrsa -des3 -out ${ROOT_CA_KEY} 4096
echo ""

echo "Generating root CA cert..."
openssl req -x509 -new -nodes -key ${ROOT_CA_KEY} -sha256 -days 1024 -subj "/C=HU/ST=Budapest/O=My CA Org/CN=myca" -out ${ROOT_CA_CRT}
echo ""

echo "Generating altnames.txt..."
echo "subjectAltName = DNS:*.acmex.com, DNS:acmex.com, DNS:acmex" > altnames.txt 
echo ""

echo "Generating certificate signing request for your domain..."
openssl req -out ${DOMAIN_CSR} -newkey rsa:2048 -nodes -subj "/C=HU/ST=Budapest/O=Acmex Org/CN=acmex" -keyout ${DOMAIN_KEY} -config san.cnf
echo ""

echo "Verifying DNS names in CSR file..."
openssl req -noout -text -in ${DOMAIN_CSR} | grep DNS
echo ""

echo "Self sigining the sertificate..."
openssl x509 -req -in ${DOMAIN_CSR} -CA ${ROOT_CA_CRT} -CAkey ${ROOT_CA_KEY} -CAcreateserial -out ${DOMAIN_CRT} -days 500 -sha256 -extfile altnames.txt
echo ""

echo "Verifying DNS names in CRT file..."
openssl x509 -in ${DOMAIN_CRT} -noout -text | grep DNS
echo ""
