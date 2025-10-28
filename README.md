# Article's Oauth API

The following material is part of a workshop for revisiting `RoR` concepts and `REST foundations` with a practical Article's API with its associated comments. The very strong focus of the workshop was on handling `TDD practices` and `API development` as well.

A lot of Ruby packages or `gems` were used for this. The whole idea was to use a `RoR API Based project` and make use of the best "standard" practices for it.

## TDD

This is a must-do process for a real full-development software cycle. Basically sets the strategy for writing `failing` tests, making them pass, and after that, improving the test (building code).

## Installing Rails (for APIs)

Assuming you have installed the `Rubylang` and the `gem` package manager.

Just `rails new api -T --api`

Check the `Gemfile` for the whole dependency listing. But worth mentioning the `rspec` package for performing TDD's

## The GitHub OAuth implementation

For this particular aspect of the API, we use a `GitHub OAuth App` for handling user authentication, but it's completely optional. This is accomplished by the `Octokit` gem.

## OAuth most common user validation and usage.

I think this is not a standardized process, but basically it splits into two processes. Let's say the user registration with the OAuth provider (GitHub), resulting in an `access_token`, which will be used in order to authorize HTTP requests to the API. The user's table of the API must internally have the access_token recorded and then perform certain validations for particular roles.

Following the development cycle used, the process goes like this.

1. The client logs in using a social provider
2. The client itself sends a code resulting from the previous action directly to the API
3. The API internally validates the `token` with the social provider used, and if it succeeds, returns the `token` back to the API. Once it's done, you can store or find the user data associated with the social profile
4. An `access token` is also created between the API and the Database, and finally returned to the `client`

## Endpoints

The structure of the JSON contains the `data` and the consequent `attribute` JSON object to pass user data to the API, for example:

1. `/login`: login process
2. `/articles` resource: the whole CRUD routes available
3. `/articles/{id}/comments` for posting and listing generated comments on a certain article
4. Other like `/logout` (for leaving API), and `/sign_up` for registration

You will need to add the `Bearer XXXXX` for the authorization needed in certain endpoints (this goes in the HTTP Header section)

The `spec/routes` for better understanding it's quite easy.

## Credits
[David Lares S](https://davidlares.com)

## License
[MIT](https://opensource.org/licenses/MIT)
