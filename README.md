# Rails 5.1 + Docker + Node

This is a skeleton project for Rails 5.1 which runs under `docker-compose` with
Postgres and Nodejs for front end stuff.

These generate smaller images than default rails image. The default image
generated by following the directions on https://docs.docker.com/compose/rails/
is **834MB** (ruby:2.3.4, Rails 5.1). In contrast, the image created this
Dockerfile using (ruby:2.3.4-alpine) is 70% smaller at **266MB**.

```
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
demo_spring         latest              c66bd150b77e        3 hours ago         266MB
demo_app            latest              c66bd150b77e        3 hours ago         266MB
ruby                2.5.0-alpine        308418a1844f        10 hours ago        60.7MB
postgres            9.6                 5579c7505b1b        6 weeks ago         268MB
```

This is built to my personal preference for managing stuff. They may not be
industry best practice and/or production worthy, but this is good for the way
I develop locally.

## Opinions

- Image should be rebuilt rarely since it takes a while.
- Bundled gems shouldn't require image rebuild. `docker-compose run app bundle install` is enough.
- Lots of data in their own volumes safe from container removals:
    - `./node_modules`
    - `/var/local/bundles`
    - `/var/lib/postgresql/data`
- Keep the image as small as possible

Many posts where reviewed when piecing this together:
- Build `Dockerfile` and `docker-compose.yml`
    - https://blog.codeship.com/build-minimal-docker-container-ruby-apps/
    - https://blog.codeship.com/using-docker-compose-for-ruby-development/
    - https://blog.codeship.com/running-rails-development-environment-docker/
    - https://stackoverflow.com/questions/40248908/context-or-workdir-for-docker-compose
- Volumes
    - https://docs.docker.com/engine/admin/volumes/
    - https://www.healthcareblocks.com/blog/persistent-ruby-gems-docker-container 
- Mac OSX Volume Caching
    - https://docs.docker.com/compose/compose-file/#caching-options-for-volume-mounts-docker-for-mac
    - https://docs.docker.com/docker-for-mac/osxfs-caching/
- Spring service
    - https://github.com/jonleighton/spring-docker-example
- Service hostname
    - https://docs.docker.com/docker-cloud/apps/service-links/
- Compose Rails
    - https://docs.docker.com/compose/rails/

## First Run

```sh
# install required gems. `run` is used since we're not ready to start all the services, yet
docker-compose run app bundle

# start up all services
docker-compose up

# create initial database
docker-compose exec db createdb -U postgres dev

# run database migrations
docker-compose exec app rake db:migrate

# install yarn
docker-compose exec app npm install -g yarn

# install node modules via yarn
docker-compose exec app yarn install
```

## Spring Loaded

A spring service is started with compose to make `rails console` load faster.

```sh
# Console
docker-compose exec spring rails c

# Generator
docker-compose exec spring rails g

# Routes
docker-compose exec spring rake routes
```

