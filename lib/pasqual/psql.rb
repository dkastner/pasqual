module Pasqual

  module Psql
    class Failed < StandardError; end

    def self.pipe(file, username, password, host, port, name)
      cmd = Command.execute 'psql', username, password, host, port, name, file

      raise AlreadyExists if cmd.output =~ /already exists/
      raise Failed unless cmd.success?
      true
    end

  end

end
