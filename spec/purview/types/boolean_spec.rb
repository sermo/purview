describe Purview::Types::Boolean do
  let(:type) { Purview::Types::Boolean }

  describe '.parse' do
    it 'parses truthy boolean values to true' do
      aggregate_failures do
        expect(type.parse('true')).to be true
        expect(type.parse('True')).to be true
        expect(type.parse('TRUE')).to be true
        expect(type.parse('1')).to be true
        expect(type.parse('t')).to be true
        expect(type.parse('y')).to be true
        expect(type.parse('YES')).to be true
      end
    end

    it 'parses falsey boolean values to true' do
      aggregate_failures do
        expect(type.parse('false')).to be false
        expect(type.parse('False')).to be false
        expect(type.parse('FALSE')).to be false
        expect(type.parse('0')).to be false
        expect(type.parse('f')).to be false
        expect(type.parse('no')).to be false
        expect(type.parse('NO')).to be false
      end
    end
  end
end
