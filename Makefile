reload:
	docker container rm container-php-nginx --force
	docker build -t image-php-nginx .
	docker run -i -p 8080:80 --name container-php-nginx image-php-nginx