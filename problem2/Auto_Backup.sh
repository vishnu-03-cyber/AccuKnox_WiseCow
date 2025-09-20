#!/bin/bash
SOURCE_DIRS=("./data" "./configs")       # DIRECTORIES TO BACKUP
BACKUP_DIR="./backups"                   # LOCAL BACKUP DESTINATION
NUM_BACKUPS_TO_KEEP=7                     # RETENTION
REMOTE_USER="username"                    # REMOTE SERVER USER
REMOTE_HOST="remote.server.com"           # REMOTE SERVER HOSTNAME/IP
REMOTE_DIR="/home/username/backups"       # REMOTE DESTINATION DIRECTORY

# CREATE LOCAL BACKUP DIRECTORY IF NOT EXISTS
mkdir -p "$BACKUP_DIR"

# CREATE TIMESTAMPED BACKUP FILE
BACKUP_FILE="$BACKUP_DIR/backup_$(date +%Y%m%d_%H%M%S).tar.gz"

# PERFORM LOCAL BACKUP
if tar -czf "$BACKUP_FILE" "${SOURCE_DIRS[@]}"; then
    echo "LOCAL BACKUP SUCCESS: $BACKUP_FILE"
else
    echo "LOCAL BACKUP FAILED!"
    exit 1
fi

# COPY BACKUP TO REMOTE SERVER
if scp "$BACKUP_FILE" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/"; then
    echo "BACKUP SUCCESSFULLY COPIED TO REMOTE SERVER: $REMOTE_HOST:$REMOTE_DIR"
else
    echo "FAILED TO COPY BACKUP TO REMOTE SERVER!"
    exit 1
fi

# REMOVE OLD LOCAL BACKUPS EXCEEDING RETENTION
NUM_BACKUPS=$(ls -1 "$BACKUP_DIR" | grep -c '^backup_')
NUM_TO_REMOVE=$((NUM_BACKUPS - NUM_BACKUPS_TO_KEEP))

if [ $NUM_TO_REMOVE -gt 0 ]; then
    OLD_BACKUPS=$(ls -1 "$BACKUP_DIR" | grep '^backup_' | sort | head -n $NUM_TO_REMOVE)
    for old in $OLD_BACKUPS; do
        rm "$BACKUP_DIR/$old"
        echo "REMOVED OLD LOCAL BACKUP: $old"
    done
fi
