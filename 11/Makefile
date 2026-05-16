#!make
include .env
include infrastructure/make/**.mk

export $(shell sed 's/=.*//' .env)

###> ALIASES ###
init: docker-down-clear api-clear \
	docker-pull docker-build docker-up \
	api-init
up: docker-up
down: docker-down
dump: db-dump
api-check: api-lint api-analyze api-test
api-retest: db-reinit api-test
api-retest-parallel: db-reinit api-test-parallel
restore: api-migration-migrate
db-startup: api-migration-migrate-on-startup
db-reinit: db-init api-migration-migrate api-fixtures-load
just-api: docker-down-clear-just-api api-clear \
	docker-pull-just-api docker-build-just-api docker-up-just-api \
	api-init db-startup api-fixtures-load
just-api-down: docker-down-just-api
test-init: docker-down-clear-test api-clear \
	docker-pull-test docker-build-test docker-up-test \
	api-prepare-for-test api-migration-fixtures-test
test-down: docker-down-test
###< ALIASES ###

###> APP ###
docker-up:
	docker-compose up -d

docker-down:
	docker-compose down --remove-orphans

docker-down-clear:
	docker-compose down -v --remove-orphans

docker-pull:
	docker-compose pull --include-deps

docker-build:
	docker-compose build

###< APP ###

###> misc ###
validate-jenkins:
	curl --user altit -X POST -F "jenkinsfile=<Jenkinsfile" https://jenkins.alt-dev.ru/pipeline-model-converter/validate
###> misc ###
