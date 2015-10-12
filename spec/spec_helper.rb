require 'rspec'

require 'purview'

require 'dotenv'
Dotenv.load('.env.local.test', '.env.test')

require 'support/helpers/raw_connection_helper'
include RawConnectionHelper

RSpec.configure do |config|
  config.color_enabled = true if config.respond_to?(:color_enabled)

  config.before(:suite) { spin_up_dbs }
end

def spin_up_dbs
  pg_config = postgresql_connection_config
  pg_config[:user] = pg_config.delete :username
  pg_config[:dbname] = pg_config.delete :database
  create_pg_db(pg_config)
  pg_conn = ::PG.connect(pg_config)
  pg_conn.exec('DROP TABLE IF EXISTS test_items')
  pg_conn.exec('CREATE TABLE test_items(i char(1), n bigint, created_at timestamp default now(), updated_at timestamp default now())')
  pg_conn.exec("INSERT INTO test_items(i, updated_at) VALUES('a', '#{earliest_populated_timestamp}')")
  pg_conn.exec("INSERT INTO test_items(i, n, updated_at) VALUES('a', 12345678900, null)")
  q=Purview::RawConnections::PG.new(postgresql_connection_config)
  puts q.execute('SELECT * FROM test_items')
end

def earliest_populated_timestamp
  Time.now - 1000
end

def create_pg_db(pg_config)
  pg_conn = ::PG.connect(pg_config.merge({ :dbname => 'postgres' }))
  db_exists = pg_conn.exec("SELECT 1 FROM pg_database WHERE datname = '#{ENV['PURVIEW_POSTGRESQL_DBNAME']}'")
  if db_exists.to_a.none?
    pg_conn.exec(create_pg_db_sql)
  end
end
