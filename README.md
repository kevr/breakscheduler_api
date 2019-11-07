# breakscheduler_api

This project contains source of a back-end API server that primarily stores persistent user data for the breakscheduler website front-end.

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

## API Endpoints

#### /users/new

Register a new user.

Parameters required: `name`, `email`, `password`, `password_confirmation`

Returns: JSON encoding of the new user object

#### /users/login

Authenticate as an existing user. This endpoint replies with a JSON object containing a token that can be used for authorization to elevated API endpoints, like `/users/me`.

Parameters required: `email`, `password`

Returns: JSON object containing a JSON web token that can be used for authorization.

    {"token": "your_authorization_token"}

#### /users/me (Authorized)

Returns: JSON encoding of the user object associated with your authorization token.

    {"id": 1, "email": "some@email.com", name: "Some Person", reset_password_token: null}

## Database Administration

This project takes advantage of the [activeadmin](https://github.com/activeadmin/activeadmin) gem. Browse to [http://<your_rails_url>/admin](#) to administer your rails instance database.

    Default Login generated using `rails generate db:seed`
    Username: admin@example.com
    Password: password