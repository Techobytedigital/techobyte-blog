# Containers

Docker containers for development & production.

Run a stack with `-f stacks/$COMPOSE_FILE`. For example, to run the [development stack](./stacks/dev.compose.yml):

```shell
docker compose -f ./scripts/dev.compose.yml up -d
```

## Instructions

* Copy [`.env.example`](./.env.example) -> `.env`
  * Edit env variables
  * Set your site URL in `HUGO_BASE_URL`.
    * You must specify a protocol (`http://`/`https://`)
  * Run with `docker compose -f containers/stacks/dev.compose.yml`, or the [Docker run script](../scripts/docker/run_docker_stack.sh).
