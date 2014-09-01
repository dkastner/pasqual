require 'pasqual/arglist'

module Pasqual

  class Command

    def self.execute(program, username, password, host, port, name)
      new(program, username, password, host, port, name).tap { |c| c.execute }
    end

    attr_accessor :program, :username, :password, :host, :port, :name,
      :output, :status

    def initialize(program, username, password, host, port, name)
      self.program = program
      self.username = username
      self.password = password
      self.host = host
      self.port = port
      self.name = name
    end

    def execute
      outfile = Tempfile.new("pasqual-#{name}")
      outfile.sync = true

      process = ChildProcess.build program,
        *Arglist.args(username, password, host, port, name)

      process.io.stdout = process.io.stderr = outfile

      if password
        # TODO: find out why piping to stdin doesn't work :(
        ENV['PGPASSWORD'] = password
        process.start
        process.poll_for_exit(30)
        ENV['PGPASSWORD'] = nil
      else
        process.start
        process.poll_for_exit(30)
      end

      outfile.rewind
      self.output = outfile.read
      self.status = process.exit_code
    end

    def success?
      status == 0
    end

  end

end
