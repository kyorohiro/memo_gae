[setup 1]
$ docker-machine create -d virtualbox dev
$ eval "$(docker-machine env dev)"
$ docker version
$ docker pull google/docker-registry
$ docker images
$ docker run google/dart /usr/bin/dart --version

[setup 2]
$ curl https://sdk.cloud.google.com | bash
$ exec -l $SHELL
--> create project
$ gcloud init
// gcloud auth login
// gcloud config set project hello
// gcloud config list


[deploy]
$ gcloud preview app deploy app.yaml --promote

[local preview]
$ dev_appserver.py --custom_entrypoint "dart bin/server.dart {port}" app.yaml
