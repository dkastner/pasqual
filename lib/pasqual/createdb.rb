require 'childprocess'
require 'tempfile'

require 'pasqual/command'

module Pasqual

  module Createdb
    class AlreadyExists < StandardError; end
    class Failed < StandardError; end

    def self.execute(username, password, host, port, name)
      cmd = Command.execute 'createdb', username, password, host, port, name

      raise AlreadyExists if cmd.output =~ /already exists/
      raise(Failed, cmd.output) unless cmd.success?
      true
    end

  end

end
