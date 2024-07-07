dc_exec=docker exec -it backend

start:
	docker-compose up -d --remove-orphans

stop:
	docker-compose down

bash:
	 $(dc_exec) bash
composer:
	$(dc_exec) composer install

install: start composer

dump:
	 docker exec -it backend-db mysqldump -u root -proot backend > dump.sql