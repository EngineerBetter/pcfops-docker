# docker-image for PCF ops pipeline

## To update the CI pipeline

```sh
vim ci/pipeline.yml
# [ ... ]
export CONCOURSE_ALIAS=eb
export EB_SECRETS_FILE=~/secrets/eb/dockerhub.yml
make ci-check-config
# \fly -t eb validate-pipeline --strict --config=ci/pipeline.yml
# looks good
make ci-pipeline
# [ ... ]
# apply configuration? [yN]: Y
# configuration updated
git add ci/pipeline.yml
git commit
git push
```
