require 'spec_helper'
require 'pasqual/database'

describe Pasqual::Database do
  let(:database) { Pasqual::Database.new ENV['DATABASE_URL'] }

  describe '#createdb' do
    let(:name) { SecureRandom.hex(10) }

    after :each do
      database.dropdb name
    end

    it 'creates a database' do
      expect(database.createdb(name)).to be true
    end

    it 'raises an error if a database already exists' do
      database.createdb name

      expect do
        database.createdb name
      end.to raise_error(Pasqual::Createdb::AlreadyExists)
    end

  end

end

