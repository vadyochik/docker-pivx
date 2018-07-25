# PIVX docker image

- *Dockerfile*: Debian based image for [PIVX](https://pivx.org/) binary [releases](https://github.com/PIVX-Project/PIVX/releases). Based on official debian:stretch-slim image.

- *Dockerfile.alpine*: Alpine based image for [PIVX](https://pivx.org/) wallet built from [sources](https://github.com/PIVX-Project/PIVX). Uses docker multi-stage builds feature (requiring Docker 17.05 or higher), based on official alpine:3.8 image.

## Examples

Build Debian based image and tag it with PIVX current version and "latest" tag:
```
docker build -t vadyochik/pivx:3.1.1 .
docker tag vadyochik/pivx:3.1.1 vadyochik/pivx:latest
```

Build Alpine based image and tag it with PIVX current version and "alpine" tag:
```
docker build -f Dockerfile.alpine -t vadyochik/pivx:3.1.1-alpine .
docker tag vadyochik/pivx:3.1.1-alpine vadyochik/pivx:alpine
```

Run pivxd process in container as simple as:
```
docker run -d --name pivx vadyochik/pivx
```

or extend the above command to smthng like:
```
docker run -d --name pivx --rm -p 51472:51472 -v pivxdata:/pivx/.pivx vadyochik/pivx 
```

Check container logs (with "Follow log output"):
```
docker logs -f pivx
```

Get info from running daemon with pivx-cli:
```
docker exec pivx pivx-cli getinfo
```

Get into the shell of the running container:
```
docker exec -it pivx /bin/bash
```

