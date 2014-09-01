require 'childprocess'
require 'tempfile'

require 'pasqual/command'

module Pasqual

  module Dropdb
    class Failed < StandardError; end

    def self.execute(username, password, host, port, name)
      cmd = Command.execute 'dropdb', username, password, host, port, name

      raise Failed unless cmd.success?
      true
    end

  end

end
