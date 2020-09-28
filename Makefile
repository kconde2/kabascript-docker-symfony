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

bpush:
	docker build --squash --tag $(DEPLOYMENT) --file `pwd`/docker/python/Dockerfile `pwd` --build-arg IS_DEV=false
	docker push $(DEPLOYMENT)

encrypt:
	chmod +x ./vault.sh && ./vault.sh encrypt

decrypt:
	chmod +x ./vault.sh && ./vault.sh decrypt
