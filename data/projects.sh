#!/bin/sh

curl -f https://api.github.com/users/jyooru/repos | jq -f projects.jq > projects.json
