#!/usr/bin/env bash
NAME="scale_nodes.sh"
ENV=$1
COUNT=$2
usage() {
    echo "./scale_nodes.sh <ENV> <NUM>"
    echo "ENV - staging or prod"
    echo "NUM - number of nodes to scale to"
    echo "ex. ./scale_nodes.sh staging 0 # STOP staging environment"
    echo "ex. ./scale_nodes.sh prod 3 # SCALE prod environment to 3 instances"
    exit
}

if [[ ! "$ENV" =~ ^(staging|prod)$ ]]; then
    echo "Invalid ENV $ENV"
    usage
fi
if [[ ! "$COUNT" =~ ^[0-9]+$ ]]; then
    echo "Invalid nodes count $COUNT"
    usage
fi
aws autoscaling  update-auto-scaling-group --auto-scaling-group-name notejam-${ENV}_asg --min-size ${COUNT} --max-size ${COUNT} --desired-capacity ${COUNT}
aws ecs update-service --service "notejam-staging-svc" --cluster "notejam-staging-ecs" --desired-count ${COUNT}
