#!/bin/bash

PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
SYMFONY_DEPLOYMENT_IMAGE=kabaconde/ansible-docker:deployment
ACTIONS=(encrypt decrypt)
CONTAINER_NAME='kabascript_actions'

cd "$PARENT_PATH"

show_usage() {
  echo "Usage: action.sh <action>

<action> is the action to perform ("encrypt", "decrypt")

Available actions:
`( IFS=$'\n'; echo "${ACTIONS[*]}" )`

Examples:
  action.sh encrypt
  action.sh decrypt
"
}

[[ $# -ne 1 ]] && { show_usage; exit 127; }

for arg
do
  [[ $arg = -h ]] && { show_usage; exit 0; }
done

ACTION="$1"; shift
[[ ! " ${ACTIONS[@]} " =~ " ${ACTION} " ]] && { show_usage; exit 0; }

# map all directory to avoid 'device busy issue'
CMD="docker run -d -it --name="$CONTAINER_NAME" \
    -v $PARENT_PATH/playbooks/:/ansible
    $SYMFONY_DEPLOYMENT_IMAGE bash"

echo $CMD
$CMD

docker exec -it $CONTAINER_NAME bash -c "
    ansible-vault $ACTION group_vars/all/vault.yml -vvvv --vault-password-file=.vault_pass
    ansible-vault $ACTION group_vars/production/vault.yml -vvvv --vault-password-file=.vault_pass
    ansible-vault $ACTION group_vars/staging/vault.yml -vvvv --vault-password-file=.vault_pass
    "

# Stop and remove container
docker container stop $CONTAINER_NAME
docker container rm /$CONTAINER_NAME
