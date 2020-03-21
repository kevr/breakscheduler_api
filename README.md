# breakscheduler_api

[![Build Status](https://travis-ci.org/kevr/breakscheduler_api.svg?branch=master)](https://travis-ci.org/kevr/breakscheduler_api)

This project contains source of a back-end API server that primarily stores persistent user data for the breakscheduler website front-end.

## Deployment

In production, we use Sidekiq for email scheduling, which requires Redis. A simple systemd service can be used to activate sidekiq. On Debian, `sudo apt-get install redis`.

    # /etc/systemd/system/sidekiq.service
    [Service]
    Type=exec
    User=www-data
    Group=www-data
    WorkingDirectory=/var/www/breakscheduler_api
    ExecStart=/bin/bash -lc './sidekiq -e production -C config/sidekiq.yml'
    ...

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
