push: push-gateway push-api
push-test-source: push-test-api
push-prepared-source: push-prepared-api

push-gateway:
	docker push ${REGISTRY}/rosinfra_v2-gateway:${IMAGE_TAG}

push-api:
	docker push ${REGISTRY}/rosinfra_v2-api:${IMAGE_TAG}
	docker push ${REGISTRY}/rosinfra_v2-api-php-fpm:${IMAGE_TAG}
	docker push ${REGISTRY}/rosinfra_v2-api-php-cli:${IMAGE_TAG}
	docker push ${REGISTRY}/rosinfra_v2-consumer:${IMAGE_TAG}
	docker push ${REGISTRY}/rosinfra_v2-cron:${IMAGE_TAG}

push-test-api:
	docker push registry2.alt-dev.ru/rosinfra_v2-api-php-fpm:ci-source
	docker push registry2.alt-dev.ru/rosinfra_v2-api-php-cli:ci-source

push-prepared-api:
	docker push registry2.alt-dev.ru/rosinfra_v2-api-php-fpm:${PHP_TAG_VERSION}
	docker push registry2.alt-dev.ru/rosinfra_v2-api-php-cli:${PHP_TAG_VERSION}

push-db:
	docker push ${REGISTRY}/rosinfra_v2-postgres:${IMAGE_TAG}