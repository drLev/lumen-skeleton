default_php_version:=8.0
default_server_port:=8080
php_version:=$(PHP_VERSION)
server_port:=$(PORT)

ifndef PHP_VERSION
	php_version:=$(default_php_version)
endif

ifndef PORT
	server_port:=$(default_server_port)
endif

base_dir:=$(shell basename $(CURDIR))
docker:=docker run --rm -v $(CURDIR):/app -w /app $(base_dir):$(php_version)

build:
	docker-compose -f docker-compose.yml build

down:
	docker-compose -f docker-compose.yml down

in:
	docker exec -ti $(base_dir)_php-fpm_1 bash

up:
	docker-compose -f docker-compose.yml up

security:
	$(docker) composer security

install:
	$(docker) composer install

install-no-dev:
	$(docker) composer install --no-dev

style:
	$(docker) composer style

style-fix:
	$(docker) composer style

static-analyze:
	$(docker) composer static-analyze

unit:
	$(docker) -dzend_extension=xdebug.so -dxdebug.mode=coverage  vendor/bin/phpunit

coverage:
	$(docker) composer coverage

all: build install security style static-analyze unit coverage

.PHONY: build