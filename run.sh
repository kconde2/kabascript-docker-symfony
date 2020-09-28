#!/bin/bash

IMAGE=kabaconde/ansible-docker:symfony-deployment

# Run deployment
docker run --rm \
    -v ~/.ssh:/tmp/.ssh:ro \
    -v $(pwd)/playbooks/group_vars/all/vault.yml:/ansible/group_vars/all/vault.yml \
    -v $(pwd)/playbooks/group_vars/production/main.yml:/ansible/group_vars/production/main.yml \
    -v $(pwd)/playbooks/group_vars/production/vault.yml:/ansible/group_vars/production/vault.yml \
    -v $(pwd)/playbooks/group_vars/staging/main.yml:/ansible/group_vars/staging/main.yml \
    -v $(pwd)/playbooks/group_vars/staging/vault.yml:/ansible/group_vars/staging/vault.yml \
    -v $(pwd)/playbooks/inventory.ini:/ansible/inventory.ini \
    -v $(pwd)/playbooks/.vault_pass:/ansible/.vault_pass \
    $IMAGE ./bin/action.sh $@
