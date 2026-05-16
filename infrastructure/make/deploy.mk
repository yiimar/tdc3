app-deploy-stage:
	ssh -o StrictHostKeyChecking=no deploy@${HOST} -p ${PORT} 'rm -rf site_${BUILD_NUMBER}'
	ssh -o StrictHostKeyChecking=no deploy@${HOST} -p ${PORT} 'mkdir site_${BUILD_NUMBER}'

	envsubst < docker-compose-stage.yml > docker-compose-stage-env.yml
	scp -o StrictHostKeyChecking=no -P ${PORT} docker-compose-stage-env.yml deploy@${HOST}:site_${BUILD_NUMBER}/docker-compose.yml
	rm -f docker-compose-stage-env.yml

	ssh -o StrictHostKeyChecking=no deploy@${HOST} -p ${PORT} 'docker login -u=${USER} -p=${PASSWORD} ${REGISTRY} && cd site_${BUILD_NUMBER} && docker stack deploy --compose-file docker-compose.yml rosinfra_v2 --with-registry-auth --prune'

app-deploy-stage-clean:
	rm -f docker-compose-stage-env.yml

app-rollback-stage:
	ssh -o StrictHostKeyChecking=no deploy@${HOST} -p ${PORT} 'cd site_${BUILD_NUMBER} && docker stack deploy --compose-file docker-compose.yml rosinfra_v2 --with-registry-auth --prune'

app-deploy-prod:
	ssh -o StrictHostKeyChecking=no deploy@${HOST} -p ${PORT} 'rm -rf site_${BUILD_NUMBER}'
	ssh -o StrictHostKeyChecking=no deploy@${HOST} -p ${PORT} 'mkdir site_${BUILD_NUMBER}'

	envsubst < docker-compose-production.yml > docker-compose-production-env.yml
	scp -o StrictHostKeyChecking=no -P ${PORT} docker-compose-production-env.yml deploy@${HOST}:site_${BUILD_NUMBER}/docker-compose.yml
	rm -f docker-compose-stage-env.yml

	ssh -o StrictHostKeyChecking=no deploy@${HOST} -p ${PORT} 'docker login -u=${USER} -p=${PASSWORD} ${REGISTRY} && cd site_${BUILD_NUMBER} && docker stack deploy --compose-file docker-compose.yml rosinfra_v2 --with-registry-auth --prune'

app-deploy-prod-clean:
	rm -f docker-compose-production-env.yml

app-rollback-prod:
	ssh -o StrictHostKeyChecking=no deploy@${HOST} -p ${PORT} 'cd site_${BUILD_NUMBER} && docker stack deploy --compose-file docker-compose.yml rosinfra_v2 --with-registry-auth --prune'