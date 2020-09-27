#!/bin/bash

shopt -s nullglob

ENVIRONMENTS=(staging production)

show_usage() {
  echo "Usage: rollback <environment> <site name> [options]

<environment> is the environment to rollback to ("staging", "production", etc)
<site name> is the site url to rollback (name defined in "my_sites")
[options] is any number of parameters that will be passed to ansible-playbook

Available environments:
`( IFS=$'\n'; echo "${ENVIRONMENTS[*]}" )`

Examples:
  rollback staging example.com
  rollback production example.com
  rollback staging example.com -vv -T 60
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
ROLLBACK_CMD="ansible-playbook rollback.yml -e env=$ENV -e site=$SITE $EXTRA_PARAMS"
HOSTS_FILE="inventory.ini"

if [[ ! -e $HOSTS_FILE ]]; then
  echo "Error: $ENV is not a valid environment ($HOSTS_FILE does not exist)."
  echo
  echo "Available environments:"
  ( IFS=$'\n'; echo "${ENVIRONMENTS[*]}" )
  exit 1
fi

echo "Running following commands"
echo $ROLLBACK_CMD
$ROLLBACK_CMD
