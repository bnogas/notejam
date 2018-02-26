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

running_ec2_instances() {
    echo $(aws ecs describe-clusters --cluster notejam-${ENV}-ecs | grep registeredContainerInstancesCount | sed -e "s:.*\([0-9]\+\).*:\1:g")
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
echo "Waiting for ec2 instances to be up"
while [[ "$(running_ec2_instances)" -lt ${COUNT} ]]; do sleep 10; echo -n "." ;done
echo
echo "Done"
aws ecs update-service --service "notejam-${ENV}-svc" --cluster "notejam-${ENV}-ecs" --desired-count ${COUNT} > /dev/null
