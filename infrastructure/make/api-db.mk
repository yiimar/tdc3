api-migration-diff:
	docker-compose run --rm api-php-cli bin/console doctrine:migrations:diff --no-interaction

api-schema-validate:
	docker-compose run --rm api-php-cli bin/console doctrine:schema:validate

api-migration-generate:
	docker-compose run --rm api-php-cli bin/console doctrine:migration:generate

api-fixtures-load:
	docker-compose run --rm api-php-cli bin/console doctrine:fixtures:load --append --no-interaction

api-migration-migrate:
	docker-compose run --rm api-php-cli bin/console doctrine:migration:migrate --no-interaction

api-migration-fixtures-test:
	docker-compose run --rm api-php-cli /bin/ash -c 'php bin/console doctrine:migration:migrate --no-interaction &&\
	bin/console doctrine:fixtures:load --append --no-interaction'

api-migration-up:
	docker-compose run --rm api-php-cli bin/console doctrine:migration:exec --up 'App\Doctrine\Migrations\Core\Version${version}' --no-interaction

api-migration-down:
	docker-compose run --rm api-php-cli bin/console doctrine:migration:exec --down 'App\Doctrine\Migrations\Core\Version${version}' --no-interaction

api-migration-migrate-on-startup:
	docker-compose run --rm api-php-cli sh -c 'echo "Updating DB..." && wait-for-postgres bin/console doctrine:migration:migrate --no-interaction'

api-doctrine-schema-upd:
	docker-compose run --rm api-php-cli bin/console app:schema:update -f

api-doctrine-db-drop:
	docker-compose run --rm api-php-cli bin/console doctrine:database:drop -f

api-doctrine-db-create:
	docker-compose run --rm api-php-cli bin/console d:d:c

api-config:
	docker-compose run --rm api-php-cli bin/console config:dump-reference ${pack}

api-console:
	docker-compose run --rm api-php-cli bin/console

api-doctrine-import:
	docker-compose run --rm api-php-cli bin/console doctrine:mapping:import "App\DomainModel" annotation --path=tmp/DomainModel

db-dump:
	docker-compose exec -u postgres api-postgres pg_dump -Fc rosinfra > db-dump.sql

db-restore:
	docker-compose exec -T api-postgres psql -U ${POSTGRES_USER} -d rosinfra < db.sql

db-init:
	docker-compose exec -T api-postgres /docker-entrypoint-initdb.d/db-init.sh