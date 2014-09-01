module Pasqual

  module Arglist

    def self.args(username, password, host, port, name)
      list = ['-h', host, '-U', username, '-p', port.to_s]
      list += ['-w'] if password.nil?

      list + [name]
    end
    
  end

end
