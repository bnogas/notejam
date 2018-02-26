#!/usr/bin/env bash
echo "=======Creating inital users and roles"
ansible-playbook ./cicd_create.yml
echo "=======Creating staging environment"
ansible-playbook ./create_env.yml --extra-vars @env_config/staging.yml
echo "=======Creating production environment"
ansible-playbook ./create_env.yml --extra-vars @env_config/prod.yml
