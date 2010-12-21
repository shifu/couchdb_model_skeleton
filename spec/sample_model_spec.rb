require 'spec_helper'

class Person < CouchRest::Model::Base
  property :name,      String
  property :lives,     Integer, :default => 9
  property :nicknames, [String]
  timestamps!
  view_by :name
end

describe Person do
  describe '.database' do
    it 'uses the correct name' do
      Person.database.name.should eq('couchdb_model_skeleton_test')
    end
  end

  describe 'a new instance' do
    before(:each) do
      @instance = Person.new
    end

    it 'validates' do
      @instance.should be_valid
    end

    it 'saves without error' do
      proc { @instance.save! }.should_not raise_error
    end
  end
end
