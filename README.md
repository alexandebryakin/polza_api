# Weuse API

# Initial setup

→ Clone the repo

→ Install `docker` and `docker-compose`

→ Copy env file by:

```bash
cp .example.env .env
```

→ Build docker by using:

```bash
docker-compose -f ./docker-compose.yml -f ./docker/development/docker-compose.yml build
```

## Start the app in the `development` environment by:

```bash
docker-compose -f ./docker-compose.yml -f ./docker/development/docker-compose.yml up -d
```

## Stop the app in the `development` environment by:

```bash
docker-compose -f ./docker-compose.yml -f ./docker/development/docker-compose.yml down
```
