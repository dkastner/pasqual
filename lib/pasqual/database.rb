require 'uri'
require 'pasqual/createdb'
require 'pasqual/dropdb'
require 'pasqual/psql'

module Pasqual

  class Database
    attr_reader :username, :password, :host, :port, :name

    def initialize(url)
      uri = URI.parse url
      @username = uri.user
      @password = uri.password
      @host = uri.host
      @port = uri.port
      @name = uri.path.sub(/^\//, '')
    end

    def port
      @port ||= 5432
    end

    def createdb(create_name = name)
      Createdb.execute username, password, host, port, create_name
    end

    def dropdb(drop_name = name)
      Dropdb.execute username, password, host, port, drop_name
    end

    def command(statement)
      Psql.command statement, username, password, host, port, name
    end

    def pipe_sql(file, dbname = name)
      Psql.pipe file, username, password, host, port, dbname
    end

  end

end
