api-init: api-composer-install api-jwt api-create-file-uploads-dir

### > Just API
JUST_API_SERVICES=gateway api api-php-fpm api-php-cli api-postgres mailer api-memcached centrifugo cron

ifeq (${ENABLE_CONSUMER},true)
	JUST_API_SERVICES += consumer rabbitmq
endif

docker-up-just-api:
	docker-compose -f ./docker-compose-backend-only.yml up -d ${JUST_API_SERVICES}

docker-down-just-api:
	docker-compose -f ./docker-compose-backend-only.yml down --remove-orphans

docker-down-clear-just-api:
	docker-compose -f ./docker-compose-backend-only.yml down -v --remove-orphans

docker-pull-just-api:
	docker-compose -f ./docker-compose-backend-only.yml pull --include-deps ${JUST_API_SERVICES}

docker-build-just-api:
	docker-compose -f ./docker-compose-backend-only.yml build ${JUST_API_SERVICES}
### < Just API

### > Test
prepare-test-containers: build-test-source push-test-source

docker-up-test:
	docker-compose -f ./docker-compose-test.yml up -d

docker-down-test:
	docker-compose -f ./docker-compose-test.yml down --remove-orphans

docker-down-clear-test:
	docker-compose -f ./docker-compose-test.yml down -v --remove-orphans

docker-pull-test:
	docker-compose -f ./docker-compose-test.yml pull --include-deps

docker-build-test:
	docker-compose -f ./docker-compose-test.yml build
### < Test

### > composer
api-composer-install:
	docker-compose run --rm api-php-cli composer install

api-composer-update:
	docker-compose run --rm api-php-cli composer update

api-composer-require:
	docker-compose run --rm api-php-cli composer require ${pack}

api-composer-remove:
	docker-compose run --rm api-php-cli composer remove ${pack}

api-check-requirements:
	docker-compose run --rm api-php-cli composer check-requirements
### < composer

### > misc
api-clear:
	docker run --rm -v ${PWD}/api:/app -w /app alpine sh -c 'rm -rf var/cache/* var/log/* var/test/*'

api-permissions:
	docker run --rm -v ${PWD}/api:/app -w /app alpine chmod 777 var/cache var/log var/test

api-jwt:
	docker-compose run --rm api-php-cli /bin/ash -c 'mkdir -p config/jwt && \
	openssl genpkey -out config/jwt/private.pem -aes256 -algorithm rsa -pkeyopt rsa_keygen_bits:4096 -pass pass:${APP_SECRET} && \
	openssl pkey -in config/jwt/private.pem -out config/jwt/public.pem -pubout -passin pass:${APP_SECRET} && \
	chmod 0755 -R config/jwt'

api-jwt-remove:
	docker-compose run --rm api-php-cli sh -c 'rm -rf config/jwt'

api-create-file-uploads-dir:
	docker-compose run --rm api-php-cli mkdir -p -m 777 /app/public/files
### < misc

### > Debug
api-debug-router:
	docker-compose run --rm api-php-cli bin/console debug:router
### < Debug

### > GIT
backend-git-hook:
	cp pre-commit-backend .git/hooks/pre-commit
	chmod 777 .git/hooks/pre-commit
### < GIT

### > Test
api-prepare-for-test:
	docker-compose run --rm api-php-cli /bin/ash -c 'composer install &&\
		mkdir -p -m 777 /app/public/files &&\
		mkdir -p config/jwt && \
		openssl genpkey -out config/jwt/private.pem -aes256 -algorithm rsa -pkeyopt rsa_keygen_bits:4096 -pass pass:${APP_SECRET} && \
		openssl pkey -in config/jwt/private.pem -out config/jwt/public.pem -pubout -passin pass:${APP_SECRET} && \
		chmod 0755 -R config/jwt'
### < Test
