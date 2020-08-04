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

the following routes are available. Note that any property in the form `[:foo]` is to be replaced with the value of `foo`. I.e. if you're looking for a task with the id of 12 you would run a GET to `/tasks/10/` not `/tasks/[:id]`. Any id will always refer to the type immediately preceding it. So `/users/[:id]/tasks` requires a user id, whereas `/tasks/[:id]/users` (if that route existed) would require a task id. Every item in the database has a unique id to be used in this way (unique on that table, not globally unique):

| Method | Route | description | parameters (contained in the body property of a fetch request) | reuturn |
| --- |  --- | --- | --- | --- |
| GET | `/users/[:id]/tasks` | Get all tasks associated with a user by user id | <ul><li>`filter` - `string`[`completed`, `uncompleted`, `all`]: returns a subset of the tasks associated with the user. defaults to `all`</li></ul> | an `array` of [task](#Task) objects |
| GET | `/tasks/[:id]` | Get a single task by task id | &mdash; | A [task](#Task) object |
| POST | `/users/[:id]/tasks` | Create a new task for user | <ul><li>`title` - `string` required.</li><li>`complete` - `boolean` defaults to `false`</li></ul> | The newly created [task](#Task) object or errors if not successful |
| PATCH | `/tasks/[:id]` | Update a task. Parameters provided will be modified to provided values, parameters not provided will remain as they were | <ul><li>`title` - `string`</li><li>`complete` - `boolean`</li></ul> | The updated [task](#Task) object |
| DELETE | `/tasks/[:id]` | Delete a task | &mdash; |  |
| POST | `/users` | Create a new user | <ul><li>`username` - `string` required</li><li>`password` - `string` required. length >= 6</li></ul> | The new [user](#User) object and an authentication key if successful. errors if not successful |
| POST | `/sessions` | Authenticate an existing user for logging in | <ul><li>`username` - `string`</li><li>`password` - `string`</li></ul> | Signed in [user](#User) object and authentication key if successful, errors if not successful |

### Database items
#### User
<ul><li><code>id</code> - <code>number</code> provided by the database on user creation.</li><li><code>username</code> - <code>string</code> required</li><li><code>password</code> - <code>string</code> required. length >= 6</li></ul>

#### Task
<ul><li><code>id</code> - <code>number</code> provided by the database on task creation.</li><li><code>title</code> - <code>string</code> required</li><li><code>complete</code> - <code>boolean</code> defaults to <code>false</code></li></ul>