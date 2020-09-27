#!/usr/bin/bash -e

ROOT_CA_KEY='rootCA.key'
ROOT_CA_CRT='rootCA.crt'
DOMAIN_CSR='mydomain.csr'
DOMAIN_KEY='mydomain.key'
DOMAIN_CRT='mydomain.crt'

if [ ! -e ${ROOT_CA_KEY} ]; then
    echo "Generating root CA key..."
    openssl genrsa -des3 -out ${ROOT_CA_KEY} 4096
    echo ""
else
    echo "${ROOT_CA_KEY} already exists, skipping generation..."
fi

if [ ! -e ${ROOT_CA_CRT} ]; then
    echo "Generating root CA cert..."
    openssl req -x509 -new -nodes -key ${ROOT_CA_KEY} -sha256 -days 1024 -subj "/C=HU/ST=Budapest/O=My CA Org/CN=myca" -out ${ROOT_CA_CRT}
    echo ""
else
    echo "${ROOT_CA_CRT} already exists, skipping generation..."
fi

echo "Generating altnames.txt..."
echo "subjectAltName = DNS:*.mydomain.com, DNS:mydomain.com, DNS:mydomain" > altnames.txt 
echo ""

echo "Generating certificate signing request for your domain..."
openssl req -out ${DOMAIN_CSR} -newkey rsa:2048 -nodes -subj "/C=HU/ST=Budapest/O=My Company/CN=mydomain" -keyout ${DOMAIN_KEY} -config san.cnf
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

echo "Add ${ROOT_CA_CRT} to your browser as a trusted CA cert!!!"
echo ""
echo "Starting python https server..."
python test.py
