# PIVX docker image

Debian based image for [PIVX](https://pivx.org/) binary [releases](https://github.com/PIVX-Project/PIVX/releases). Based on official debian:stretch-slim image.

## Examples

Run pivxd process in container as simple as:

`docker run -d --name pivx vadyochik/pivx` 

or extend the above command to smthng like:

`docker run -d --name pivx -p 51472:51472 -v pivxdata:/pivx/.pivx vadyochik/pivx` 

To check container logs (with "Follow log output"):

`docker logs -f pivx`

To get to the shell of the running container:

`docker exec -it pivx /bin/bash`

