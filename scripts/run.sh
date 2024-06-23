#!/bin/bash
set -e

# Restore the database if it does not already exist.
if [ -f /pb/pb_data/data.db ]; then
	echo "Database already exists, skipping restore"
else
	echo "No database found, restoring from replica if exists"
	litestream restore -if-db-not-exists -if-replica-exists /pb/pb_data/data.db 
fi

# Run litestream with your app as the subprocess.
exec litestream replicate -exec "/usr/local/bin/pocketbase --dir /pb/pb_data serve --http 0.0.0.0:8090"