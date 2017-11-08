require 'pasqual/arglist'

module Pasqual

  class Command

    def self.execute(program, username, password, host, port, name, file = nil)
      new(program, username, password, host, port, name, file).tap { |c| c.execute }
    end

    attr_accessor :program, :username, :password, :host, :port, :name, :file,
      :output, :status

    def initialize(program, username, password, host, port, name, file = nil)
      self.program = program
      self.username = username
      self.password = password
      self.host = host
      self.port = port
      self.name = name
      self.file = file
    end

    def execute
      outfile = Tempfile.new("pasqual-#{name}")
      outfile.sync = true

      process = ChildProcess.build program,
        *Arglist.args(program, username, password, host, port, name)

      process.io.stdout = process.io.stderr = outfile

      process.duplex = true if file

      # TODO: find out why piping to stdin doesn't work :(
      ENV['PGPASSWORD'] = password
      process.start

      if file && File.exist?(file)
        File.open file do |f|
          process.io.stdin.puts f.read
          process.io.stdin.flush
        end
        process.io.stdin.close
      elsif file
        process.io.stdin.puts file
        process.io.stdin.flush
        process.io.stdin.close
      end

      process.wait
      ENV['PGPASSWORD'] = nil

      outfile.rewind
      self.output = outfile.read
      self.status = process.exit_code
    end

    def success?
      status == 0
    end

  end

end
