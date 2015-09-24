describe Purview::RawConnections::PG do
  subject(:pg) do
    Purview::RawConnections::PG.new(postgresql_connection_config)
  end

  describe '#execute' do
    it 'can run arbitrary sql and return the results' do
      results = pg.execute('SELECT * FROM test_items')
      expect(results.rows[0][:i]).to eq('a')
    end
  end

  describe '#disconnect' do
    it 'prevents further queries from executing' do
      pg.disconnect

      expect { pg.execute('SELECT * FROM test_items') }.to raise_error
    end
  end
end
