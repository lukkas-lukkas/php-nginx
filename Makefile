build-run:
	docker container rm php-nginx-container --force
	docker build -t php-nginx-image .
	docker run -i -p 8080:80 --name php-nginx-container php-nginx-image