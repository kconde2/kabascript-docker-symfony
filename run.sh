#!/bin/bash

PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
SYMFONY_DEPLOYMENT_IMAGE=kabaconde/ansible-docker:symfony-deployment

cd "$PARENT_PATH"

# Run deployment
docker run --rm \
    -v ~/.ssh:/tmp/.ssh:ro \
    -v $PARENT_PATH/playbooks/group_vars/all/vault.yml:/ansible/group_vars/all/vault.yml \
    -v $PARENT_PATH/playbooks/group_vars/production/main.yml:/ansible/group_vars/production/main.yml \
    -v $PARENT_PATH/playbooks/group_vars/production/vault.yml:/ansible/group_vars/production/vault.yml \
    -v $PARENT_PATH/playbooks/group_vars/uat/main.yml:/ansible/group_vars/uat/main.yml \
    -v $PARENT_PATH/playbooks/group_vars/uat/vault.yml:/ansible/group_vars/uat/vault.yml \
    -v $PARENT_PATH/playbooks/inventory.ini:/ansible/inventory.ini \
    -v $PARENT_PATH/playbooks/.vault_pass:/ansible/.vault_pass \
    $SYMFONY_DEPLOYMENT_IMAGE ./bin/action.sh $@
