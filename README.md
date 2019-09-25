# docker-image for PCF ops pipeline

## To update the CI pipeline

These instructions assume you are already authenticated with EBCI with the `fly` CLI on your machine.

```sh
git clone git@github.com:EngineerBetter/pcfops-docker.git
cd pcfops-docker
fly --target ebci set-pipeline --pipeline pcfops-docker --config ci/pipeline.yml
```
