#!/usr/bin/env bash
echo "=======Creating inital users and roles"
ansible-playbook ./cicd_create.yml
echo "=======Creating staging environment"
ansible-playbook ./create_env.yml --extra-vars @env_config/staging.yml
sh generate_dashboard.sh staging > dashboards/dashboard-staging.json
aws cloudwatch put-dashboard --dashboard-name "notejam-staging" --dashboard-body file://dashboards/dashboard-staging.json
echo "=======Creating production environment"
ansible-playbook ./create_env.yml --extra-vars @env_config/prod.yml
sh generate_dashboard.sh prod > dashboards/dashboard-prod.json
aws cloudwatch put-dashboard --dashboard-name "notejam-prod" --dashboard-body file://dashboards/dashboard-prod.json
