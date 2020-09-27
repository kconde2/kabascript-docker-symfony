# KabaScript for Dockerized Symfony Application

KabaScript for Dockerized Symfony Application is set of Ansible playbooks to make symfony deployment easy, secured and reusable with Docker in production or staging servers.

## Requirements

Make sure all dependencies have been installed before moving on:

- Docker >= 19.03.12
- Docker-compose >= 1.27.2

Windows user? Not tested Todo :)

## Installation

- Copy either `inventory.ini.exemple` into `inventory.ini` and edit it
- Make sure to setting these files :

```shell
ansible/group_vars/all/vault.yml
ansible/group_vars/production/vault.yml
ansible/group_vars/staging/vault.yml
```

Depending on hosts you define in `ìnventory.ini`, update staging in `ansible/group_vars/staging/vault.yml` with the correct host, like this :

```shell
ansible/group_vars/<host-your-defined-in-inventory>/vault.yml
```

In case you want to encrypt your vault files and you must, generate one :

```shell
openssl rand -base64 64 > .vault_pass
```

## Usage

```
./run.sh -h
```

Example :

```shell
./run.sh staging example.com -v
```

## Know issues

- For AWS EC2 server make sure to `chmod 400 ~/.ssh/aws-edu.pem`
- [Ansible python interpreter](https://www.toptechskills.com/ansible-tutorials-courses/how-to-fix-usr-bin-python-not-found-error-tutorial/)
- When deploying to use ssh forwarding, run this : [ssh forwarding](https://roots.io/docs/trellis/master/ssh-keys/#cloning-remote-repo-using-ssh-agent-forwarding)

On MacOS

```shell
ssh-add -K
```

Inside Docker container, we have to make sure `ssh_add` is working to be able to clone project

```shell
docker-compose exec master zsh
eval "$(ssh-agent -s)"
ssh-add
ansible-playbook deploy.yml -e env=staging -e site=google.dev.site.com
```

## Resources

- [Configure ansible ubuntu](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-ansible-on-ubuntu-18-04)
- [I Spun up a Scalable WordPress Server Environment with Trellis, and You Can, Too](https://css-tricks.com/i-spun-up-a-scalable-wordpress-server-environment-with-trellis-and-you-can-too/)
- [Run ansible on localhost](https://www.middlewareinventory.com/blog/run-ansible-playbook-locally/)
- [Keep docker host user permissions](https://jtreminio.com/blog/running-docker-containers-as-current-host-user/)
- [Docker forwarding](https://medium.com/@dperny/forwarding-the-docker-socket-over-ssh-e6567cfab160)
- [Run tasks on remotely ssh server](https://ansiblemaster.wordpress.com/2016/04/29/run-ansible-tasks-to-a-remote-server-using-a-ssh-tunnel/)
- [Run task inside ansible docker](https://stackoverflow.com/questions/59828696/how-to-connect-to-run-an-ansible-task-inside-a-docker-container-on-a-remote-host?answertab=active#tab-top)


## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

We have [contributing guidelines](CONTRIBUTING.md) to help you get started.

## Credits

- [Laravan](https://github.com/jsphpl/laravan/blob/master/.gitlab-ci.yml.example)
- [Trellis](https://github.com/roots/trellis)
- [Ansible + Docker](https://gist.github.com/ttwthomas/017891e536f745dcbcc5d0bc160a2643)
- [Trellis Deployments](https://roots.io/docs/trellis/master/deployments/)

## License
[MIT](https://choosealicense.com/licenses/mit/)
