#!/bin/bash -e

if [ -n "$NPM_BUILD_USER" ] && [ -n "$NPM_BUILD_PASS" ]; then
    echo "exporting NPM_BUILD_AUTH for user $NPM_BUILD_USER"
    export NPM_BUILD_AUTH=$( echo -n "${NPM_BUILD_USER}:${NPM_BUILD_PASS}" | openssl base64 )
elif [ -n "$NPM_BUILD_AUTH" ]; then
    echo "NPM_BUILD_AUTH not available"
    exit 1
fi
