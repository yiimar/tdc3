api-backend-test: api-lint api-phpstan api-psalm api-test

api-lint:
	docker-compose run --rm api-php-cli composer lint
	docker-compose run --rm api-php-cli composer cs-check

api-fix:
	docker-compose run --rm api-php-cli composer cs-fix

api-analyze: api-phpstan api-psalm

api-test:
	docker-compose run --rm api-php-cli composer test

api-test-parallel:
	docker-compose run --rm api-php-cli composer test-parallel

api-test-iriis:
	docker-compose run --rm api-php-cli composer test-iriis

api-phpstan:
	docker-compose run --rm api-php-cli composer phpstan

api-psalm:
	docker-compose run --rm api-php-cli composer psalm /app

api-test-coverage:
	docker-compose run --rm api-php-cli composer test-coverage

api-all-test-with-output:
	docker-compose run --rm api-php-cli bin/phpunit --log-junit var/analyze/phpunit/phpunit.result.xml

api-default-test-with-output:
	docker-compose run --rm api-php-cli bin/phpunit --exclude-group large --log-junit var/analyze/phpunit/phpunit.result.xml

api-analyze-test-env:
	docker-compose run --rm api-php-cli /bin/ash -c "composer lint && composer phpstan && composer psalm /app"