require "pasqual/version"
require 'pasqual/database'

module Pasqual

  def self.new
    self.for ENV['DATABASE_URL']
  end

  def self.for(url)
    Database.new url
  end

end
