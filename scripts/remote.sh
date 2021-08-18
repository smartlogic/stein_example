#!/bin/bash

# Per project settings

git_repo="https://github.com/smartlogic/stein_example"

# Generalized starts below

ssh_user="deploy"
ssh_options=""
ssh_port=22

help_text=$(cat <<"HELP"
remote.sh - Help manage remote nodes

  remote.sh [production|staging|local] [command]

Commands:

bash    Start a remote bash shell

diff    Diff the currently deployed version against `origin/main`

help    View this help message

iex     Start a remote IEx shell

logs    Tail logs from a remote server. Note if there are more than one server
        to connect to, only one will be tailed. See the script if you need to
        follow more than one server for how to do that.

psql    Start a remote psql connection
HELP
)

case "${1}" in
  staging)
    environment=staging
    ssh_host=$(ansible all --list-hosts -l staging | sed -n 2p | xargs)
    ;;

  production)
    environment=production
    ssh_host=$(ansible all --list-hosts -l production | sed -n 2p | xargs)
    ;;

  local)
    environment=local
    ssh_host=127.0.0.1
    ssh_port=2222
    ssh_options="-o StrictHostKeyChecking=no -o PasswordAuthentication=no -o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes"
    ;;

  *)
    echo "${help_text}"
    exit 1
    ;;
esac

ssh_command="ssh ${ssh_host} -l ${ssh_user} -p ${ssh_port} ${ssh_options}"

case "${2}" in
  bash)
    $ssh_command -t -C 'export $(cat /etc/stein_example.env | xargs) && bash'
    ;;

  diff)
    git_sha=$(${ssh_command} -C 'cat apps/stein_example/current/REVISION')
    github_url="${git_repo}/compare/${git_sha}..main"

    cat <<GITDIFF
Diff URL for ${environment}:

${github_url}
GITDIFF

    if command -v xdg-open &> /dev/null
    then
      echo "Opening..."
      xdg-open "${github_url}" 1> /dev/null
    fi

    if command -v open &> /dev/null
    then
      echo "Opening..."
      open "${github_url}"
    fi
    ;;

  iex)
    ${ssh_command} -t -C "cd apps/stein_example/current && ./bin/stein_example remote"
    ;;

  logs)
    ${ssh_command} -t -C 'journalctl -u stein_example -f'
    ;;

  psql)
    ${ssh_command} -t -C 'source /etc/stein_example.env && psql $DATABASE_URL'
    ;;

  *)
    echo "${help_text}"
    ;;
esac
