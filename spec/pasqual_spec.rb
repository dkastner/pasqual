require 'spec_helper'
require 'securerandom'
require 'pasqual'

describe Pasqual do

  describe '.new' do

    it 'returns a Pasqual::Database configured for a URL' do
      p = Pasqual.new
      expect(p).to be_a(Pasqual::Database)
    end

  end

end

