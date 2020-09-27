#!/bin/bash

# Important to put this inside same shell session
# in order to remember ssh credentials
eval "$(ssh-agent -s)"
ssh-add && echo "Deployment begins"

shopt -s nullglob

ENVIRONMENTS=(staging production)

show_usage() {
  echo "Usage: deploy <environment> <site name> [options]

<environment> is the environment to deploy to ("staging", "production", etc)
<site name> is the site url to deploy (name defined in "my_sites")
[options] is any number of parameters that will be passed to ansible-playbook

Available environments:
`( IFS=$'\n'; echo "${ENVIRONMENTS[*]}" )`

Examples:
  deploy staging example.com
  deploy production example.com
  deploy staging example.com -vv -T 60
"
}

[[ $# -lt 2 ]] && { show_usage; exit 127; }

for arg
do
  [[ $arg = -h ]] && { show_usage; exit 0; }
done

ENV="$1"; shift
SITE="$1"; shift
EXTRA_PARAMS=$@
DEPLOY_CMD="ansible-playbook deploy.yml -e env=$ENV -e site=$SITE $EXTRA_PARAMS"
HOSTS_FILE="inventory.ini"

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
