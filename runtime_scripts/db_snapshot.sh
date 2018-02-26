#!/usr/bin/env bash
OP=$1
ENV=$2
SNAPSHOT=$3
usage() {
    echo "./db_snapshot.sh <OP> <ENV> <SNAPSHOT>"
    echo "Create/list or delete db snapshots"
    echo "OP - list|create|delete"
    echo "ENV - staging or prod"
    echo "SNAPSHOT - snapshot name"
    echo "ex. ./db_snapshot.sh list prod"
    echo "ex. ./db_snapshot.sh create prod snapshot_name"
    exit
}

if [[ ! "$OP" =~ ^(create|list|delete|restore)$ ]]; then
    echo "Invalid OP $OP"
    usage
fi
if [[ ! "$ENV" =~ ^(staging|prod)$ ]]; then
    echo "Invalid ENV $ENV"
    usage
fi

if [[ $OP == "list" ]]; then
    aws rds describe-db-snapshots --db-instance-identifier "notejam-${ENV}"
    exit
fi

if [ -z $SNAPSHOT ]; then
    echo "Missing snapshot name"
    usage
fi

if [[ $OP == "create" ]]; then
    aws rds create-db-snapshot --db-instance-identifier "notejam-${ENV}"  --db-snapshot-identifier "${SNAPSHOT}"
    exit
fi

if [[ $OP == "delete" ]]; then
    aws rds delete-db-snapshot  --db-snapshot-identifier "${SNAPSHOT}"
    exit
fi
