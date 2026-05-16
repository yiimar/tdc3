standalone-build: build-rabbit build-memcached build-centrifugo
standalone-push: push-rabbit push-memcached push-centrifugo

build-rabbit:
	docker --log-level=debug build --pull --file=infrastructure/docker/rabbitmq/rabbitmq.dockerfile --tag=${REGISTRY}/rosinfra_v2-rabbit:${RABBIT_TAG} .

build-centrifugo:
	docker --log-level=debug build --pull --file=infrastructure/docker/centrifugo/centrifugo.dockerfile --tag=${REGISTRY}/rosinfra_v2-centrifugo:${CENTRIFUGO_TAG} .

build-memcached:
	docker --log-level=debug build --pull --file=infrastructure/docker/memcached/memcached.dockerfile --tag=${REGISTRY}/rosinfra_v2-memcached:${MEMCACHED_TAG} ./

push-rabbit:
	docker push ${REGISTRY}/rosinfra_v2-rabbit:${RABBIT_TAG}

push-centrifugo:
	docker push ${REGISTRY}/rosinfra_v2-centrifugo:${CENTRIFUGO_TAG}

push-memcached:
	docker push ${REGISTRY}/rosinfra_v2-memcached:${MEMCACHED_TAG}