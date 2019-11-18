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

#### POST /users/new

Register a new user.

Parameters required: `name`, `email`, `password`, `password_confirmation`

Returns: JSON encoding of the new user object

#### POST /users/login

Authenticate as an existing user. This endpoint replies with a JSON object containing a token that can be used for authorization to elevated API endpoints, like `/users/me`.

Parameters required: `email`, `password`

Returns: JSON object containing a JSON web token that can be used for authorization.

    {"token": "your_authorization_token"}

#### GET /users/me (Authorized)

Returns: JSON encoding of the user object associated with your authorization token.

    {"id": 1, "email": "some@email.com", name: "Some Person", reset_password_token: null}

#### GET /members

Returns: JSON encoded list of all members of the Break Scheduler team.

#### GET /members/:member_id

Returns: JSON encoded object of a member correlated to :member_id.

#### GET /articles

Returns: JSON encoded list of all guide articles.

    [
        {
            "id": 1,
            "title": "Article Title",
            "body": "Article's body content."
        }
    ]

#### GET /articles/:article_id

Returns: JSON encoded object representing article which has id :article_id.

    {
        "id": 1,
        "title": "Some Article",
        "body": "Some article content."
    }

#### GET /topics

Returns: JSON encoded list of all searchable help topics.

    [
        {
            "id": 1,
            "subject": "A Topic Subject",
            "body": "A topic's content"
        }
    ]

#### GET /topics/:topic_id

Returns: JSON encoded object of a topic with id :topic_id.

    {
        "id": 1,
        "subject": "First subject",
        "body": "First body!"
    }

#### POST /topics

Parameters required: `terms`

Returns: JSON encoded list of search results matched by `terms`.

    [
        {
            "id": 1,
            "subject": "First subject",
            "body": "First body"
        },
        [
            "id": 2,
            "subject": "Second subject",
            "body": "Second body"
        ]
    ]

## Database Administration

This project takes advantage of the [activeadmin](https://github.com/activeadmin/activeadmin) gem. Browse to [http://<your_rails_url>/admin](#) to administer your rails instance database.

    Default Login generated using `rails generate db:seed`
    Username: admin@example.com
    Password: password