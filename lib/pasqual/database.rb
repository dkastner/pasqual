require 'uri'
require 'pasqual/createdb'
require 'pasqual/dropdb'

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

    def createdb(name)
      Createdb.execute username, password, host, port, name
    end

    def dropdb(name)
      Dropdb.execute username, password, host, port, name
    end

  end

end
