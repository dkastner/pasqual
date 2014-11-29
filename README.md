# Pasqual

Run Postgres CLI commands with the help of database settings configured with environment variables.

![](https://travis-ci.org/dkastner/pasqual.svg?branch=master)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pasqual'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pasqual

## Usage

First, get an instance of Pasqual: 

``` ruby
psql = Pasqual.for ENV['DATABASE_URL']
```

### createdb

Createdb automatically uses the database name defined in `ENV`.

```ruby
psql.createdb
```

A custom name can optionally be specified:

```ruby
psql.createdb 'foodb'
```

### dropdb

Dropdb automatically uses the database name defined in `ENV`.

```ruby
psql.dropdb
```
A custom name can optionally be specified:

```ruby
psql.dropdb 'foodb'
```

### command

Executes an SQL script, the same as piping text into the psql command.

```ruby
psql.command "SELECT * from users;"
```

### pipe

You can pipe a file into the `psql` command:

```ruby
psql.pipe_sql '/path/to/file.sql'
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/pasqual/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
