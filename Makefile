NAME =	frozenbytes/readthedocs

build:
	docker build -t $(NAME) .

release:
	docker push $(NAME)

compose-up:
	docker-compose up -d --no-recreate
compose-up-rc:
	docker-compose up -d 
run:
	docker-compose run --service-ports --rm readthedocs
debug-run:
	docker-compose run --service-ports --rm readthedocs bash
debug-app:
	docker exec -ti dockerreadthedocs_readthedocs_run_9 bash
