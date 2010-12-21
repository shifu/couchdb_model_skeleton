# Copyright (c) Henry Poydar

# Modified from couchrest-rails
# A Rails plugin for connecting to and working with CouchDB via CouchRest
# https://github.com/hpoydar/couchrest-rails/

begin

  env = Rails.env.to_s || 'development'

  couchdb_config = YAML::load(ERB.new(IO.read(Rails.root.to_s << '/config/couchdb.yml')).result)[env]

  host      = couchdb_config['host']      || 'localhost'
  port      = couchdb_config['port']      || '5984'
  database  = couchdb_config['database']
  username  = couchdb_config['username']
  password  = couchdb_config['password']
  ssl       = couchdb_config['ssl']       || false
  db_prefix = couchdb_config['database_prefix'] || %q{}
  db_suffix = couchdb_config['database_suffix'] || %q{_} << Rails.env.to_s
  host     = 'localhost'  if host == nil
  port     = '5984'       if port == nil
  ssl      = false        if ssl == nil

  protocol = ssl ? 'https' : 'http'
  authorized_host = (username.blank? && password.blank?) ? host : "#{CGI.escape(username)}:#{CGI.escape(password)}@#{host}"

rescue

  raise "There was a problem with your config/couchdb.yml file. Check and make sure it's present and the syntax is correct."

else

  COUCHDB_CONFIG = {
    :host_path => "#{protocol}://#{authorized_host}:#{port}",
    :db_prefix => "#{db_prefix}",
    :db_suffix => "#{db_suffix}",
  }

  database_name = "#{db_prefix}#{database}#{db_suffix}"

  COUCHDB_SERVER = CouchRest.new COUCHDB_CONFIG[:host_path]
  COUCHDB_SERVER.default_database = database_name
end

# Set default database in all models
CouchRest::Model::Base.class_eval { use_database COUCHDB_SERVER.default_database }
