#!/usr/bin/make
SHELL = /bin/sh

# Автоматическое определение ID пользователя для исключения проблем с правами в Linux
UID := $(shell id --user)
GID := $(shell id --group)
export UID
export GID

# Подключаем переменные окружения только если файл .env существует
ifneq ($(wildcard .env),)
    include .env
    export $(shell sed 's/=.*//' .env)
endif

# Объявляем все цели как .PHONY во избежание конфликтов с одноименными файлами
.PHONY: init up down restart \
        docker-up docker-down docker-down-clear docker-pull docker-build \
        project-clear project-permissions app-init app-deps-install app-deps-update \
        app-wait-db app-migrations app-fixtures app-test validate-jenkins

###====================================================================
###> АЛИАСЫ ВЕРХНЕГО УРОВНЯ (Основные команды для разработки)
###====================================================================

# Полный холодный запуск проекта с нуля (с очисткой старых контейнеров и логов)
init: docker-down-clear project-clear docker-pull docker-build docker-up app-init

up: docker-up
down: docker-down
restart: down up

###====================================================================
###> УПРАВЛЕНИЕ DOCKER COMPOSE
###====================================================================

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

###====================================================================
###> СЛУЖЕБНЫЕ КОМАНДЫ ОЧИСТКИ И ПРАВ (Запуск через один контейнер)
###====================================================================

# Агрегированная быстрая очистка кэша, логов и s3-хранилища из-под root
project-clear:
	docker run --rm \
		--volume "${PWD}/app":/app \
		--volume "${PWD}/storage":/storage \
		alpine:3.23 sh -c 'rm -rf /app/var/cache/* /app/var/log/* /app/var/test/* /storage/app/* /storage/s3/*'

# Агрегированная выдача прав для корректной работы PHP-FPM / CLI внутри Docker
project-permissions:
	docker run --rm \
		--volume "${PWD}/app":/app \
		--volume "${PWD}/storage":/storage \
		alpine:3.23 sh -c 'chmod 777 /app/var/cache /app/var/log /app/var/test && chmod -R 777 /storage'

###====================================================================
###> ВНУТРЕННЯЯ ИНИЦИАЛИЗАЦИЯ И СБОРКА ПРИЛОЖЕНИЯ APP (Yii3)
###====================================================================

# Пошаговый запуск внутренних процессов приложения после поднятия контейнеров
app-init: project-permissions app-deps-install app-wait-db app-migrations app-fixtures

app-deps-install:
	docker compose run --rm app-php-cli composer install

app-deps-update:
	docker compose run --rm app-php-cli composer update

# Ожидание готовности СУБД PostgreSQL (предотвращает race condition при миграциях)
app-wait-db:
	docker compose run --rm app-php-cli wait-for-it app-postgres:5432 -t 30

# Запуск миграций Yii3 в неинтерактивном режиме
app-migrations:
	docker compose run --rm app-php-cli composer app migrations:migrate -- --no-interaction

# Заливка фикстур Yii3 для локальной разработки / тестов
app-fixtures:
	docker compose run --rm app-php-cli composer app fixtures:load

# Запуск тестового люкса (Unit / Integration / Codeception)
app-test:
	docker compose run --rm app-php-cli composer test

###====================================================================
###> ВСПОМОГАТЕЛЬНЫЕ КОМАНДЫ (CI/CD)
###====================================================================

validate-jenkins:
	curl --user altit -X POST -F "jenkinsfile=<Jenkinsfile" https://alt-dev.ru
