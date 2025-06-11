#!/bin/bash

# Find the port for Digital Piano
PIANO_PORT=$(aconnect -l | awk '
  BEGIN { client="" }
  /client [0-9]+:.*Digital Piano/ { client=$2; gsub(":", "", client) }
  /0 .Digital Piano MIDI 1/ { if (client != "") print client ":0" }
')

# Find the port for reface CP
REFACE_PORT=$(aconnect -l | awk '
  BEGIN { client="" }
  /client [0-9]+:.*reface CP/ { client=$2; gsub(":", "", client) }
  /0 .reface CP MIDI 1/ { if (client != "") print client ":0" }
')

# Check if both ports were found
if [[ -z "$PIANO_PORT" || -z "$REFACE_PORT" ]]; then
  echo "Could not find Digital Piano or reface CP MIDI ports."
  exit 1
fi

# Display found ports
echo "Digital Piano port: $PIANO_PORT"
echo "reface CP port:       $REFACE_PORT"

# Connect Piano → reface
aconnect "$PIANO_PORT" "$REFACE_PORT"

# Connect reface → Piano
aconnect "$REFACE_PORT" "$PIANO_PORT"

# Confirm
echo "Connected"
