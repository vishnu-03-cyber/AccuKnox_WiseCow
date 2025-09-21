#!/usr/bin/env bash

# Wisecow server
SRVPORT=4499

# Check if dependencies exist
check_dependencies() {
  for cmd in fortune cowsay nc; do
    if ! command -v $cmd >/dev/null 2>&1; then
      echo "Error: $cmd is not installed. Please install it first."
      exit 1
    fi
  done
}

# Start HTTP server
start_server() {
  echo "Wisecow server running on port $SRVPORT..."
  while true; do
    RESPONSE=$(fortune | cowsay)
    echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n<pre>$RESPONSE</pre>" \
      | nc -l -p $SRVPORT -q 1
  done
}

check_dependencies
start_server

