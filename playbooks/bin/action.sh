#!/bin/bash

ACTIONS=(deploy rollback)
ENVIRONMENTS=(uat production)

# Important to put this inside same shell session
# in order to remember ssh credentials
pkill -f 'ssh-agent -s'
eval "$(ssh-agent -s)"
for possiblekey in ${HOME}/.ssh/*; do
    if grep -q PRIVATE "$possiblekey"; then
        ssh-add "$possiblekey"
    fi
done
echo "Deployment begins"

show_usage() {
  echo "Usage: run.sh <action> <environment> <site name> [options]

<action> is the action to perform ("deploy", "rollback")
<environment> is the environment to rollback to ("uat", "production", etc)
<site name> is the site url to rollback (name defined in "my_sites")
[options] is any number of parameters that will be passed to ansible-playbook

Available actions:
`( IFS=$'\n'; echo "${ACTIONS[*]}" )`

Available environments:
`( IFS=$'\n'; echo "${ENVIRONMENTS[*]}" )`

Examples:
  run.sh deploy uat example.com
  run.sh rollback production example.com
  run.sh deploy uat example.com -vv -T 60
  run.sh rollback uat example.com
"
}

[[ $# -lt 3 ]] && { show_usage; exit 127; }

for arg
do
  [[ $arg = -h ]] && { show_usage; exit 0; }
done


# TODO: check all necessary files here
# ex. ansible/group_vars/all/vault.yml ...

ACTION="$1"; shift
ENV="$1"; shift
SITE="$1"; shift
EXTRA_PARAMS=$@
DEPLOY_CMD="ansible-playbook $ACTION.yml -e env=$ENV -e site=$SITE $EXTRA_PARAMS"
PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
HOSTS_FILE="$PARENT_PATH/../inventory.ini"

if [[ ! -e $HOSTS_FILE ]]; then
  echo "Error: $ENV is not a valid environment ($HOSTS_FILE does not exist)."
  echo
  echo "Available environments:"
  ( IFS=$'\n'; echo "${ENVIRONMENTS[*]}" )
  exit 1
fi

echo "Running following commands"
echo $DEPLOY_CMD
$DEPLOY_CMD
