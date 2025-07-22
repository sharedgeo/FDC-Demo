Cloning
-------

	git clone --recursive git@github.com:SharedGeo/FDC-Demo

Building
--------

	docker-compose build
	  or
	podman-compose build

Note: The postgis:17-3.5 image isn't available on arm64 and needs to be build on that platform.

Note: podman needs a patch to docker-postgis to find the postgres:17-bullseye base image

	cd vendor/docker-postgis
	git apply ../docker-postgis-use-fully-qualified-repo.patch

Starting
--------

	docker-compose up -d
	  or
	podman-compose up -d

Stopping
--------

	docker-compose down
	  or
	podman-compose down

Endpoints:
----------

https://localhost:4443/ -> FDC-Server (and example-client for now)
https://localhost:4443/map/ -> FDC-Client (eventually move to /)
https://localhost:4443/docs/ -> FDC-Docs
