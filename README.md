# README

## Configuring this on your machine

### Running tasks:

Tasks are run via docker. prefix any rails, rake, or bundle tasks with `docker-compose run web`.

Use docker to get the image and install things (To be updated!).

### Starting this app:

if everything is installed and ready:
`docker-compose up`

## API DOCS:

### Routes
Server will start on `http://localhost:3000`. Prepend all requests with `http://localhost:3000` to get the actual route. For instance: `http://localhost:3000/users/[:id]/tasks`.

Note that this host url will change if/when this is deployed to production. localhost only references your local server you're running your machine!

the following routes are available. Note that any property in the form `[:foo]` is to be replaced with the value of `foo`. I.e. if you're looking for a task with the id of 12 you would run a GET to `/tasks/10/` not `/tasks/[:id]`. Every item in the database has a unique id to be used in this way (unique on that database table, not globally unique between all tables):

| Method | Route | Description | Parameters (contained in the body property of a fetch request) | Return |
| --- |  --- | --- | --- | --- |
| GET | `/tasks` | Get all tasks associated with the authorized user | <ul><li>`filter` - `string`[`complete`, `not complete`, `all`]: returns a subset of the tasks associated with the user. defaults to `all`</li></ul> | An object with a key of "tasks" going to an `array` of [task](#Task) objects |
| GET | `/tasks/[:id]` | Get a single task by task id | &mdash; | A [task](#Task) object |
| POST | `/tasks` | Create a new task for the authorized user | `task` going to an object with the following properties: <ul><li>`title` - `string` required.</li><li>`complete` - `boolean` defaults to `false` if not passed</li></ul> | The newly created [task](#Task) object or errors if not successful |
| PATCH | `/tasks/[:id]` | Update a task. Parameters provided will be modified to provided values, parameters not provided will remain as they were | <ul><li>`title` - `string`</li><li>`complete` - `boolean`</li></ul> | The updated [task](#Task) object |
| DELETE | `/tasks/[:id]` | Delete a task | &mdash; | &mdash; |
| POST | `/users` | Create a new user | `user` going to an object with the following properties: <ul><li>`username` - `string` required</li><li>`password` - `string` required. length >= 6</li></ul> | The new [user](#User) object and an authentication key if successful. errors if not successful |
| POST | `/sessions` | Authenticate an existing user for logging in | <ul><li>`username` - `string`</li><li>`password` - `string`</li></ul> | Signed in [user](#User) object and authentication key if successful, errors if not successful |

### Passing data in a POST or PATCH request

To pass data as part of your request you need to ensure that you have the header `Content-Type` set to `application/json` and set the body of the request to the data you wish to pass.
for instance, to make a POST request to create a new user a fetch requst might look like the following:
```
fetch('http://localhost:3000/users', {
  method: 'POST',
headers: {
      'Content-Type': 'application/json'
    },
  body: JSON.stringify({user: {username: 'foo', password: 'foobar'}})
}).then(response => response.json()).then(response => console.log(response))
```
That code will console log the response from the server to your properly formatted request.

### Authorization

The two routes handling authorization (POST to `/users` and POST to `/sessions`) both return an auth token in the body of the request.
This token is required to use any other route.

If a token is not provided on a route that is not specifically in place to handle authentication the request will return a 401 FORBIDDEN status and will not give you the data or make the changes you requested.
The tokens should be submitted in an "Authorization" header on your request. The token itself should be prepended by the string `Bearer ` (note the trailing space).

The following code is an example of a fetch request with authorization (it assumes you have a local variable `token`: a valid auth token for that user)
```
fetch(`http://localhost:3000/tasks',{
  method: 'GET',
  headers: {
    'Authorization': `Bearer ${ token }`
  }
}).then(res => res.json()).then(res => console.log(res));
```

These tokens can be stored in [local storage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage) and will expire after 14 days.
A future enhancement (if requested) might allow for using a currently valid token to create a new token to allow for a refresh of the timeout.

### Database items
#### User
<ul><li><code>id</code> - <code>number</code> provided by the database on user creation.</li><li><code>username</code> - <code>string</code> required</li><li><code>password</code> - <code>string</code> required. length >= 6</li></ul>

#### Task
<ul>
  <li><code>id</code> - <code>number</code> provided by the database on task creation.</li>
  <li><code>user_id</code> - <code>number</code> the id of the user who owns this task.</li>
  <li><code>title</code> - <code>string</code> required</li>
  <li><code>complete</code> - <code>boolean</code> defaults to <code>false</code></li>
  <li><code>created_at</code> - <code>string</code> A parsable dateTime object of when the task was initialized</li>
  <li><code>updated_at</code> - <code>string</code> A parsable dateTime object of when the task was most recently changed</li>
</ul>