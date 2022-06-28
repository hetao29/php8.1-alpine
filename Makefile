build:
	docker build . -t hetao29/php8.1-alpine:latest
push:
	docker tag hetao29/php8.1-alpine:latest hetao29/php8.1-alpine:1.0.0
	docker push -a hetao29/php8.1-alpine
startdocker:
	docker stack deploy --with-registry-auth -c docker-compose.yml php-fpm8
stopdocker:
	docker stack rm php-fpm8
