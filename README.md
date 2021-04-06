# README

### Folder Structure
* app/assets
* app/channels
* app/controllers
* app/errors
* app/grids
* app/helpers
* app/javascript
* app/jobs
* app/mailers
* app/models
* app/policies
* app/views
* config
* db
* public
* storage
* test

# Installation
The application expects a configuration file called `application.yml` in the `config` folder that contains the credentials.
An example configuration is shown below. A postgres database is required.
````yaml
# Add configuration values here, as shown below.
#
# pusher_app_id: "2954"
# pusher_key: 7381a978f7dd7f9a1117
# pusher_secret: abdc3b896a0ffb85d373
# stripe_api_key: sk_test_2J0l093xOyW72XUYJHE4Dv2r
# stripe_publishable_key: pk_test_ro9jV5SNwGb1yYlQfzG17LHK
#
# production:
#   stripe_api_key: sk_live_EeHnL644i6zo4Iyq4v1KdV9H
#   stripe_publishable_key: pk_live_9lcthxpSIHbGwmdO941O1XVU
development:
    DATABASE_NAME: 'yaht'
    DATABASE_USERNAME: 'postgres'
    DATABASE_PASSWORD: ''
    DEVISE_JWT_SECRET_KEY: 'your-secret'
test:
  DATABASE_USERNAME: 'postgres'
  DATABASE_PASSWORD: ''
  DATABASE_URL: postgres://127.0.0.1
  DATABASE_NAME: 'yaht_test'
  DEVISE_JWT_SECRET_KEY: 'your-secret' # run '$ rails secret' to generate it
````

### Installing Postgres
Run `brew install postgres`
Automatically launching it at startup / login: `brew services start postgresql`
Or without a background service: ` pg_ctl -D /usr/local/var/postgres start`

Create a user and a database:
1. Run the interactive console: `psql postgres -h localhost`
2. Run `CREATE USER postgres SUPERUSER; CREATE DATABASE yaht OWNER postgres;`
3. Run `CREATE DATABASE yaht_test OWNER postgres;`

### Installing Redis
Run `brew install redis`

### Running Tests / Spec Files
Run `bundle exec rspec spec`

## Workaround for gem `puma` on MacOS

If the gem installation of `puma` fails, i.e. the error `ctype.h missing from puma_http11.c` is thrown, the following workaround can be used:

    $ bundle config build.puma --with-cflags="-Wno-error=implicit-function-declaration"

(see https://github.com/puma/puma/issues/2304#issuecomment-664448309)

# Database Migration / Reset / Seeding
Database migrations can be run using `rake db:migrate`.
If the database needs to be reset / built from scratch the following commands can be used (*NEVER RUN THESE IN PRODUCTION*):
```bash
rake db:drop
rake db:create
rake db:migrate
```
If you only want to rollback a single migration use `rake db:rollback STEP=1`.

To seed the database with dummy data use `rake db:seed`. If you add new models then please also add them to the `config/seeds.rb` file.

### Useful commands for creating migrations
#### Add a new column to a table
```bash
rails g migration add_amount_to_items amount:integer
```



# Ruby Cheatsheet
#### Quickly Testing Methods in the Rails Console
The `rails c` command can be used in the terminal to open the rails console and to directly interact with the application without using the interface.
```ruby
 Lesson.find_by_slug("literaturgeschichte").add_author(User.first)
```
This will also output the corresponding database queries that are executed.
#### Safely Accessing an Attribute
```ruby
self.parent&.closed?
```
The `&` safe navigation operator can be used to prevent any nil errors.


### Generating Models + Migrations
```bash
$ rails generate model Article title:string body:text
```
- `:string` is for small data types such as a title
- `:text` is for longer pieces of textual data, i.e. paragraphs
- `:integer` for whole numbers
- `:decimal` for decimals (use when numbers need to be really precise)
- `:float` also for decimals (use when you don't care about precision too much i.e. only 3-4 significant digits) [Explanation](https://stackoverflow.com/questions/8514167/float-vs-decimal-in-activerecord)
- `:boolean` is for storing true or false values
- `:date` store only the date
- `:datetime` store the date and time into a column (handles timezone)
- `:timestamp` for storing date and time into a column (timezone independent)
- `:binary` is for storing data such as images, audio, or movies
- `:primary_key` unique key that can uniquely identify each row in a table
- `:references` will create a reference to the id of the model for a 'belongs_to' relationship

#### Adding A Column to an existing Model
```bash
$ rails generate migration add_email_to_users email:string
```