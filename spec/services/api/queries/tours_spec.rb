RSpec.describe Api::Queries::Tours do
  let(:params) do
    {
      fields: 'name,key'
    }
  end

  subject { described_class.new(params) }

  context '#filter_records' do
    context 'difficulty_levels filter' do
      it 'returns correct filter string if filters are given' do
        params.merge!({ filters: { difficulty: 'easy,medium' } })
        expect(subject.difficulty_levels_filter).to eq({ difficulty: %w[easy medium] })
      end

      it 'returns nil if no filter values given' do
        params.merge!({ filters: {} })
        expect(subject.difficulty_levels_filter).to be_nil
      end
    end

    context 'discounts filter' do
      it 'returns correct filter string if filters are given' do
        params.merge!({ filters: { price_discount: '10,25' } })
        expect(subject.discounts_filter).to eq({ price_discount: %w[10 25] })
      end

      it 'returns nil if no filter values given' do
        params.merge!({ filters: {} })
        expect(subject.discounts_filter).to be_nil
      end
    end

    context 'order clause' do
      it 'returns default string if not given' do
        expect(subject.order_clause).to eq('id DESC')
      end

      it 'returns string with correct order based on sign' do
        params.merge!({ sort: '-duration,name,price,-price_discount' })
        expect(subject.order_clause).to eq('duration DESC,name ASC,price ASC,price_discount DESC')
      end
    end
  end
end
