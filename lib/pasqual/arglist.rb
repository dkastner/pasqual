module Pasqual

  module Arglist

    def self.args(program, username, password, host, port, name)
      list = []
      list << '-h' << host if host.to_s.length > 0
      list << '-U' << username if username.to_s.length > 0
      list << '-p' << port.to_s if port.to_s.length > 0
      list << '-w' if password.to_s.length == 0
      if program == 'psql'
        list << '--no-psqlrc'
        list << '--pset' << 'pager=off'
      end

      list + [name]
    end
    
  end

end
