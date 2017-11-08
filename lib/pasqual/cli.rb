require 'thor'

require 'pasqual'

module Pasqual
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc "create DATABASE_URL", "create database"
    def create(url = nil)
      puts "Creating #{pasqual(url).name}"
      pasqual(url).createdb
    rescue Pasqual::Createdb::AlreadyExists
      puts "#{pasqual(url).name} already exists, skipped creation"
    end

    desc "drop DATABASE_URL", "drop database"
    def drop(url = nil)
      puts "Dropping #{pasqual(url).name}"
      pasqual(url).dropdb
    rescue Pasqual::Dropdb::Failed
      puts "Could not drop #{pasqual(url).name}, skipped"
    end

    desc "poll DATABASE_URL", "poll for the existence of a database server"
    def poll(url = nil)
      say "Waiting for Postgres to come available"
      if attempt_connect(url)
        say "Connected!"
        exit 0
      else
        say "Failed to connect"
        exit 1
      end
    end

    desc "reset [SQL_FILE] [DATABASE_URL]", "drop, create, structure"
    def reset(path = nil, url = nil)
      drop(url)
      create(url)
      file(path, url) if path
    end

    desc "psql [SQL] [DATABASE_URL]", "start a psql console or run an SQL statement"
    def psql(*cmd_args)
      url = nil
      sql_args = []
      cmd_args.each do |arg|
        if arg =~ /postgres:/
          url = arg
        else
          sql_args << arg
        end
      end
      db = pasqual(url)
      args = Pasqual::Arglist.
        args('psql', db.username, db.password, db.host, db.port, db.name)
      if sql_args.any?
        args << '-c'
        args += sql_args.map(&:inspect)
        puts "Executing in #{db.name}: #{sql_args.inspect}"
      else
        cmd = "psql #{args.join(' ')}"
      end
      puts "Running #{cmd}"
      Kernel.exec({ 'PGPASSWORD' => db.password }, "psql #{args.join(' ')}")
    end

    
    desc "file PATH [DATABASE_URL]", "execute an SQL script in a file"
    def file(path, url = nil)
      puts "Structuring #{pasqual(url).name}"
      pasqual(url).pipe_sql path
    rescue Errno::EPIPE
      puts "#{pasqual(url).name} doesn't exist, skipped structure"
    end

    private

    def pasqual(url)
      @pasqual ||= Pasqual.for(url || ENV['DATABASE_URL'])
    end

    def pg_connection(url, no_db: false)
      db = pasqual(url)
      conn = PG::Connection.connect_start(
        host: db.host,
        port: db.port,
        dbname: no_db ? nil : db.name,
        user: db.username,
        password: db.password,
        connect_timeout: (60 * 5))
    end

    def attempt_connect(url)
      require 'pg'

      timeout = Time.now.to_i + (60 * 5)

      # Don't connect to a specific database because we may be polling the
      # the server to know whether we can _create_ a database yet.
      conn = pg_connection(url, no_db: true)
      status = conn.connect_poll
      while(Time.now.to_i < timeout && status != PG::PGRES_POLLING_OK) do
        sleep 2
        status = conn.connect_poll

        conn = pg_connection(url, no_db: true) if status == PG::PGRES_POLLING_FAILED
        puts "Status: #{status.inspect}, Timeout: #{Time.now.to_i - timeout}" if ENV['DEBUG']
      end
      conn.finish
      status == PG::PGRES_POLLING_OK
    end

  end
end
