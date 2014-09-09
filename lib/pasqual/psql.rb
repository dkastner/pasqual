module Pasqual

  module Psql
    class Failed < StandardError; end

    def self.pipe(file, username, password, host, port, name)
      cmd = Command.execute 'psql', username, password, host, port, name, file

      raise Failed unless cmd.success?
      true
    end

    def self.command(statement, username, password, host, port, name)
      cmd = Command.execute 'psql', username, password, host, port, name, statement

      raise Failed unless cmd.success?
      cmd.output
    end

  end

end
