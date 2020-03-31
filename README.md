# breakscheduler_api

[![Build Status](https://travis-ci.org/kevr/breakscheduler_api.svg?branch=master)](https://travis-ci.org/kevr/breakscheduler_api)

This project contains source of a back-end API server that primarily stores persistent user data for the breakscheduler website front-end.

## Deployment

To deploy under production, we have a various number of dependencies.

* RVM
    * **gems**: bundle, bundler
* NVM
    * **packages**: yarn
* Redis

#### Setup a webhost user

To host this project in production under nginx, we require a user with read and write access to it's own home directory, as well as an nginx install destination. Login to your server as root, and add a user called (for the purposes of this README: `www`).

    # useradd -s /bin/bash -m www

#### Give webhost user sudo capability for setup

**NOTE**: This should be reversed after initial project deployment is complete.

    # gpasswd -a www sudo

#### Configure RVM as `www`

    $ rvm install 2.5.5
    $ rvm --default use 2.5.5

#### Install RVM Gems

    $ gem install bundle
    $ bundle install

#### Configure NVM as `www`

    $ nvm install 10
    $ nvm use 10

#### Install Required NVM Packages

    $ npm install -g yarn
    $ yarn install

#### Configure `.railsrc` with some required environment variables.

    $ cat .railsrc
    gmail_username='notification@email.com'
    gmail_password='password'
    SECRET_KEY_BASE='absolutelySecretBase'

#### Configure Project

Alright. That's all the project configuration required to run it. Now, migrate the database and seed the example admin user.

    $ RAILS_ENV=production ./rails db:migrate
    $ RAILS_ENV=production ./rails db:seed

Finally, we'll install nginx via compilation through passenger.

    # Create nginx directory where we'll install
    $ sudo mkdir -p /opt/nginx
    $ sudo chown www /opt/nginx

    $ passenger-install-nginx-module

Follow through the prompts and write out to `/opt/nginx`. After, you may want to setup some systemd services to run `nginx` and/or `sidekiq` on boot. Following are some examples of systemd services that can be used for this purpose (see `./services`).

    # /etc/systemd/systemd/nginx.service
    [Unit]
    Description=Simple nginx server compiled with RVM passenger

    [Service]
    Type=forking
    User=www
    Group=www
    EnvironmentFile=/home/www/breakscheduler_api/.railsrc
    ExecStart=/opt/nginx/sbin/nginx
    ExecStop=/usr/bin/killall -9 nginx

    [Install]
    WantedBy=multi-user.target

For email scheduling, we use Sidekiq, which requires `Redis`. On Debian, run `sudo apt-get install redis`.

    # /etc/systemd/system/sidekiq.service
    [Unit]
    Description=Sidekiq scheduler service

    [Service]
    Type=simple
    User=www
    Group=www
    WorkingDirectory=/home/www/breakscheduler_api
    ExecStart=/bin/bash -lc 'sidekiq -e production -C config/sidekiq.yml'
    
    [Install]
    WantedBy=multi-user.target

## API Authorization

This project's API generally requires an HTTP Authorization token provided by the client. A token can be retrieved via the `/users/login` endpoint.

First, retrieve an authorization token.

    curl -X POST --data '{"email": "email@example.org", "password": "abcd1234}' \
        http://localhost:5000/users/login
    {"token": "your_authorization_token"}

Now you can access elevated endpoints by providing the `Authorization` HTTP header.

    curl -H 'Authorization: Token your_authorization_token' \
        http://localhost:5000/users/me
    {"id": 1, "email": "email@example.org", "name": "Email Example", "reset_password_token": null}

## Database Administration

This project takes advantage of the [activeadmin](https://github.com/activeadmin/activeadmin) gem. Browse to [http://<your_rails_url>/admin](#) to administer your rails instance database.

    Default Login generated using `rails generate db:seed`
    Username: admin@example.com
    Password: password
    