#!/bin/bash

# Stop current container and wipe old data
sudo docker-compose down
sudo rm -rf /mnt/postgres_data/*

# Pull fresh data from Node 1
sudo pg_basebackup -h 172.31.12.103 -D /mnt/postgres_data -U replicator -v -P --wal-method=stream

# Set as standby and add connection info
sudo touch /mnt/postgres_data/standby.signal
sudo bash -c "echo \"primary_conninfo = 'host=172.31.12.103 port=5432 user=replicator password=1234545'\" >> /mnt/postgres_data/postgresql.conf"

# Fix permissions and start
sudo chown -R 999:999 /mnt/postgres_data
sudo docker-compose up -d
