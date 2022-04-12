reload:
	docker container rm container-php-nginx --force
	docker build -t image-php-nginx .
	docker run -p 8080:8080 -h container-php-nginx image-php-nginx