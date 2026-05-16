build-stage: build-gateway build-api
build-prod: build-gateway-production build-api-production
build-prepared-source: build-source-api

build-gateway:
	docker --log-level=debug build --pull --file=gateway/docker/stage/nginx/nginx.dockerfile --tag=${REGISTRY}/rosinfra_v2-gateway:${IMAGE_TAG} gateway/docker

build-api:
	docker --log-level=debug build --pull --file=api/docker/stage/nginx/nginx.dockerfile --tag=${REGISTRY}/rosinfra_v2-api:${IMAGE_TAG} api
	envsubst < api/.env.stage > api/.env
	docker --log-level=debug build --pull --file=api/docker/stage/php-fpm/php.dockerfile --tag=${REGISTRY}/rosinfra_v2-api-php-fpm:${IMAGE_TAG} api
	docker --log-level=debug build --pull --file=api/docker/stage/php-cli/php.dockerfile --tag=${REGISTRY}/rosinfra_v2-api-php-cli:${IMAGE_TAG} api
	docker --log-level=debug build --pull --file=api/docker/stage/consumer/consumer.dockerfile --tag=${REGISTRY}/rosinfra_v2-consumer:${IMAGE_TAG} api
	docker --log-level=debug build --pull --file=api/docker/stage/cron/cron.dockerfile --tag=${REGISTRY}/rosinfra_v2-cron:${IMAGE_TAG} api
	rm -f api/.env

build-source-api:
	docker --log-level=debug build --pull --file=api/docker/test/php-fpm/php-build.dockerfile --tag=registry2.alt-dev.ru/rosinfra_v2-api-php-fpm:${PHP_TAG_VERSION} api
	docker --log-level=debug build --pull --file=api/docker/test/php-cli/php-build.dockerfile --tag=registry2.alt-dev.ru/rosinfra_v2-api-php-cli:${PHP_TAG_VERSION} api

build-db:
	docker --log-level=debug build --pull --file=api/docker/stage/postgres/postgres.dockerfile --tag=${REGISTRY}/rosinfra_v2-postgres:${IMAGE_TAG} api

build-gateway-production:
	docker --log-level=debug build --pull --file=gateway/docker/production/nginx/nginx.dockerfile --tag=${REGISTRY}/rosinfra_v2-gateway:${IMAGE_TAG} gateway/docker

build-api-production:
	docker --log-level=debug build --pull --file=api/docker/production/nginx/nginx.dockerfile --tag=${REGISTRY}/rosinfra_v2-api:${IMAGE_TAG} api
	envsubst < api/.env.prod > api/.env
	docker --log-level=debug build --pull --file=api/docker/production/php-fpm/php.dockerfile --tag=${REGISTRY}/rosinfra_v2-api-php-fpm:${IMAGE_TAG} api
	docker --log-level=debug build --pull --file=api/docker/production/php-cli/php.dockerfile --tag=${REGISTRY}/rosinfra_v2-api-php-cli:${IMAGE_TAG} api
	docker --log-level=debug build --pull --file=api/docker/production//consumer/consumer.dockerfile --tag=${REGISTRY}/rosinfra_v2-consumer:${IMAGE_TAG} api
	docker --log-level=debug build --pull --file=api/docker/production/cron/cron.dockerfile --tag=${REGISTRY}/rosinfra_v2-cron:${IMAGE_TAG} api
	rm -f api/.env

build-clean: api-jwt-remove build-clean-env

build-clean-env:
	rm -f api/.env