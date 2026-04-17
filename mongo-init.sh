#!/bin/sh
set -eu

MARKER="/data/db/.mongo_lab_initialized"

if [ ! -f "$MARKER" ]; then
  echo "[init] first startup, initializing Mongo users"

  mongod --dbpath /data/db --bind_ip 127.0.0.1 --port 27017 --fork --logpath /tmp/mongod-init.log

  tries=0
  until mongosh --quiet --host 127.0.0.1 --port 27017 --eval 'db.runCommand({ping:1})' >/dev/null 2>&1; do
    tries=$((tries + 1))
    if [ "$tries" -gt 60 ]; then
      echo "[init] mongod did not become ready"
      cat /tmp/mongod-init.log || true
      exit 1
    fi
    sleep 1
  done

  mongosh --host 127.0.0.1 --port 27017 /docker-entrypoint-initdb.d/mongo-init.js

  mongod --dbpath /data/db --shutdown

  touch "$MARKER"
  echo "[init] initialization complete"
fi

echo "[init] starting mongod with real config"
exec mongod --config /etc/mongod.conf

