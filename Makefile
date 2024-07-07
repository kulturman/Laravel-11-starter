dc_exec=docker exec -it backend

start:
	docker-compose up -d --remove-orphans

stop:
	docker-compose down

bash:
	 $(dc_exec) bash

composer:
	$(dc_exec) composer install

php-stan:
	$(dc_exec) ./vendor/bin/phpstan analyse --memory-limit=2G

check-style:
	$(dc_exec) ./vendor/bin/pint --test

fix-style:
	$(dc_exec) ./vendor/bin/pint

install: start composer

dump:
	 docker exec -it backend-db mysqldump -u root -proot backend > dump.sql
