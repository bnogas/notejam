#!/usr/bin/env bash
if [ $# -ne 2 ]; then
    echo "./restore_db_snapshot.sh <SNAPSHOT_NAME> <NEW_DB_INSTANCE_NAME>"
    exit
fi
SNAPSHOT_NAME=$1
DB_INSTANCE_NAME=$2
aws rds restore-db-instance-from-db-snapshot --db-instance-identifier ${DB_INSTANCE_NAME} --db-snapshot-identifier ${SNAPSHOT_NAME}

