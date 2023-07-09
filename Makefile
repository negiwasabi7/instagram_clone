RUN := run --rm
DOCKER_COMPOSE_RUN := docker-compose $(RUN)
args := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))

init:
	@make build
	@make bundle.install
	@make db.create
	@make db.migrate
	@make db.seed

build:
	docker compose build

rebuild:
	docker compose build --force-rm --no-cache

up:
	docker compose up

upd:
	docker compose up -d

down:
	docker compose down

attach:
	docker attach (docker-compose ps -q app)

bash:
	${DOCKER_COMPOSE_RUN} app bash

bundle.install:
	${DOCKER_COMPOSE_RUN} app bundle install

bundle.update:
	${DOCKER_COMPOSE_RUN} app bundle update

console:
	${DOCKER_COMPOSE_RUN} app rails c

db.console:
	${DOCKER_COMPOSE_RUN} app rails dbconsole

db.create:
	${DOCKER_COMPOSE_RUN} app rails db:create
	${DOCKER_COMPOSE_RUN} app rails db:create RAILS_ENV=test

db.migrate:
	${DOCKER_COMPOSE_RUN} app rails db:migrate
	${DOCKER_COMPOSE_RUN} app rails db:migrate RAILS_ENV=test

db.seed:
	${DOCKER_COMPOSE_RUN} app rails db:seed

db.reset:
	${DOCKER_COMPOSE_RUN} app rails db:migrate:reset
	@make dbseed

annotate:
	${DOCKER_COMPOSE_RUN} app annotate

rails:
	${DOCKER_COMPOSE_RUN} app rails $(args)

rspec:
	${DOCKER_COMPOSE_RUN} -e RAILS_ENV=test app rspec $(args)

rubocop:
	${DOCKER_COMPOSE_RUN} app rubocop $(args)

rubocop.fix:
	${DOCKER_COMPOSE_RUN} app rubocop -a

brakeman:
	${DOCKER_COMPOSE_RUN} app brakeman

down.all:
	if [ -n "`docker ps -q`" ]; then docker kill `docker ps -q`; fi
		docker container prune -f

credential.edit:
	${DOCKER_COMPOSE_RUN} -e EDITOR=vim app rails credentials:edit -e $(args)
