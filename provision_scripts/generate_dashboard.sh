#!/usr/bin/env bash
env=$1
alb=`aws elbv2 describe-load-balancers --names notejam-${env}-lb | grep LoadBalancerArn | sed -e "s:.*loadbalancer/\(.*\)\",:\1:g" |tr -d '[:space:]'`
targetgroup=`aws elbv2 describe-target-groups --names notejam-${env}-target-group |grep TargetGroupArn | sed -e "s:.*\:\(.*\)\",:\1:g" | tr -d '[:space:]'`
cat dashboards/dashboard.json | sed -e "s:APP_ALB:${alb}:g"  -e "s:APP_TARGET:${targetgroup}:g" -e "s:ENV:${env}:g"
