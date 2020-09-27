#!/bin/bash

ACTIONS=(deploy rollback)
ENVIRONMENTS=(staging production)
IMAGE=kabaconde/ansible-docker-symfony

show_usage() {
  echo "Usage: run.sh <action> <environment> <site name> [options]

<action> is the action to perform ("deploy", "rollback")
<environment> is the environment to rollback to ("staging", "production", etc)
<site name> is the site url to rollback (name defined in "my_sites")
[options] is any number of parameters that will be passed to ansible-playbook

Available actions:
`( IFS=$'\n'; echo "${ACTIONS[*]}" )`

Available environments:
`( IFS=$'\n'; echo "${ENVIRONMENTS[*]}" )`

Examples:
  run.sh deploy staging example.com
  run.sh rollback production example.com
  run.sh deploy staging example.com -vv -T 60
  run.sh rollback staging example.com
"
}

[[ $# -lt 3 ]] && { show_usage; exit 127; }

for arg
do
  [[ $arg = -h ]] && { show_usage; exit 0; }
done

ACTION="$1"; shift

# TODO: check all necessary files here
# ex. ansible/group_vars/all/vault.yml ...

# Run deployment
docker run --rm \
    -v ~/.ssh:/tmp/.ssh:ro \
    -v $(pwd)/playbooks/group_vars/all/vault.yml:/root/ansible/group_vars/all/vault.yml \
    -v $(pwd)/playbooks/group_vars/production/main.yml:/root/ansible/group_vars/production/main.yml \
    -v $(pwd)/playbooks/group_vars/production/vault.yml:/root/ansible/group_vars/production/vault.yml \
    -v $(pwd)/playbooks/group_vars/staging/main.yml:/root/ansible/group_vars/staging/main.yml \
    -v $(pwd)/playbooks/group_vars/staging/vault.yml:/root/ansible/group_vars/staging/vault.yml \
    -v $(pwd)/playbooks/inventory.ini:/root/ansible/inventory.ini \
    -v $(pwd)/playbooks/.vault_pass:/root/ansible/.vault_pass \
    $IMAGE ./bin/$ACTION.sh $@
