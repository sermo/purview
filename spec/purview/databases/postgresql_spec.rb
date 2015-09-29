describe Purview::Databases::PostgreSQL do
  subject(:db) do
    db_config = db_config_convert(postgresql_connection_config)
    db_config[:database_name] = db_config.delete(:database_database)
    puller_opts = db_config.merge({
      :type => Purview::Pullers::PostgreSQL,
      :table_name => table_name,
      #:timeout => timeout,
      #:is_function => is_function?
    })
    tbl_opts = {
      :columns => [
        Purview::Columns::Id.new(:id),
        Purview::Columns::CreatedTimestamp.new(:created_at),
        Purview::Columns::UpdatedTimestamp.new(:updated_at),
        table_columns
      ].flatten,
      :loader => { :type => Purview::Loaders::PostgreSQL },
      :parser => { :type => Purview::Parsers::SQL },
      :puller => puller_opts,
      #:earliest_timestamp => earliest_timestamp
    }
    tables = [
      Purview::Tables::Raw.new('test_items_spec', tbl_opts)
    ]
    Purview::Databases::PostgreSQL.new(
      postgresql_connection_config[:database],
      db_config
        .merge(db_options)
        .merge({ :tables => tables })
    )
  end
  let(:db_options) { {
      #:logger => { :message_length => 750 },
      #:baseline_window_size => THREE_MONTHS
  } }
  let(:table_name) { 'test_items' }
  let(:table_columns) {
    []
  }

  describe '#execute_ad_hoc_sql' do
    it 'can run arbitrary sql and return the results' do
      results = db.execute_ad_hoc_sql('SELECT * FROM test_items')
      expect(results.rows[0][:i]).to eq('a')
    end
  end

  describe 'support bigint data type TODO: move to types/...' do
    it 'can store bigint values' do

    end
  end
end

=begin
    {
      :database_host => data_warehouse_raw_database_host,
      :database_username => 'postgres',
      :database_password => 'FishyB33f!',
      :tables => data_warehouse_raw_database_tables,
    }
=end
