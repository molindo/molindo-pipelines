#!/bin/bash -e

if [ -n "$NPM_REGISTRY_USER" ] && [ -n "$NPM_REGISTRY_PASS" ]; then
    echo "exporting NPM_REGISTRY_AUTH for user $NPM_REGISTRY_USER"
    export NPM_REGISTRY_AUTH=$( echo -n "${NPM_REGISTRY_USER}:${NPM_REGISTRY_PASS}" | openssl base64 )
elif [ -n "$NPM_REGISTRY_AUTH" ]; then
    echo "NPM_REGISTRY_AUTH not available"
    exit 1
fi
