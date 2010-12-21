require 'spec_helper'

describe 'Test environment' do
  describe 'CouchDB server' do
    it 'exists' do
      COUCHDB_SERVER.should be_a CouchRest::Server
    end
  end

  describe 'default database' do
    before(:each) do
      @db = COUCHDB_SERVER.default_database
      @expected_name = 'couchdb_model_skeleton_test'
    end

    it 'is actually a database' do
      @db.should be_a CouchRest::Database
    end

    it 'is properly named' do
      @db.name.should eq @expected_name
    end

    it 'is inherited by new instances of CouchRest::Model::Base' do
      class UndecoratedBaseInstance < CouchRest::Model::Base; end
      UndecoratedBaseInstance.database.name.should eq @expected_name
    end
  end
end
