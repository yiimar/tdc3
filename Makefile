SHELL = /bin/sh

UID := $(shell id --user)
GID := $(shell id --group)

export UID
export GID

init: init-ci

app-init: docker-down-clear \
          app-clear \
          docker-pull docker-build docker-up \
          app-init
up: docker-up
down: docker-down
restart: down up

docker-up:
	docker compose up --detach

docker-down:
	docker compose down --remove-orphans

docker-down-clear:
	docker compose down --volumes --remove-orphans

docker-pull:
	docker compose pull

docker-build:
	docker compose build --pull

app-clear:
	docker run --rm --volume "${PWD}/app":/app --workdir /app alpine:3.23 sh -c 'rm -rf var/cache/* var/log/* var/test/*'

app-init: app-permissions app-deps-install app-wait-db app-migrations app-fixtures

app-permissions:
	docker run --rm --volume "${PWD}/app":/app --workdir /app alpine:3.23 chmod 777 var/cache var/log var/test

app-deps-install:
	docker compose run --rm app-php-cli composer install

app-deps-update:
	docker compose run --rm app-php-cli composer update

app-wait-db:
	docker compose run --rm app-php-cli wait-for-it app-postgres:5432 -t 30

app-migrations:
	docker compose run --rm app-php-cli composer app migrations:migrate -- --no-interaction

app-fixtures:
	docker compose run --rm app-php-cli composer app fixtures:load

app-test:
	docker compose run --rm app-php-cli composer test

