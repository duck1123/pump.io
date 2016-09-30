#!/bin/sh

# Generate config from environment variables
sigil -p -f pump.io.json.tpl > /etc/pump.io.json

./bin/pump
