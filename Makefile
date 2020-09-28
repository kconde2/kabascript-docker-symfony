DEPLOYMENT=kabaconde/ansible-docker:symfony-deployment

idt:
	docker-compose exec ansible ansible-playbook server.yml --tags="mysql, pma"
iall:
	docker-compose exec ansible ansible-playbook server.yml
up:
	docker-compose up -d --build

down:
	docker-compose down

restart: down up

bash:
	docker-compose exec ansible bash

deploy:
	docker-compose run --rm ansible ./bin/deploy.sh ${env} ${site} -v

rollback:
	docker-compose run --rm ansible ./bin/rollback.sh ${env} ${site} -v

generate-vault-pass:
	docker-compose run --rm ansible bash -c 'openssl rand -base64 64 > .vault_pass'

encrypt-vault:
	docker-compose run --rm ansible ansible-vault encrypt group_vars/all/vault.yml
	docker-compose run --rm ansible ansible-vault encrypt group_vars/production/vault.yml
	docker-compose run --rm ansible ansible-vault encrypt group_vars/staging/vault.yml

decrypt-vault:
	docker-compose run --rm ansible ansible-vault decrypt group_vars/all/vault.yml
	docker-compose run --rm ansible ansible-vault decrypt group_vars/staging/vault.yml
	docker-compose run --rm ansible ansible-vault decrypt group_vars/production/vault.yml

bpush:
	docker build --squash --tag $(DEPLOYMENT) --file `pwd`/docker/python/Dockerfile `pwd` --build-arg IS_DEV=false
	docker push $(DEPLOYMENT)
