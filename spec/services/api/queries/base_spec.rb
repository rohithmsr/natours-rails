RSpec.describe Api::Queries::Base do
  let(:params) do
    {
      fields: 'name,key',
      filters: {}
    }
  end

  context 'Tests with Tours' do
    subject { described_class.new(params) }

    context 'pagination' do
      let!(:tour1) { create(:tour) }
      let!(:tour2) { create(:tour, :easier_tour) }
      let!(:tour3) { create(:tour, :harder_tour) }

      it 'returns all records' do
        paginated_records = subject.send(:paginate, Tour.all)
        expect(paginated_records).to contain_exactly(tour1, tour2, tour3)
      end

      it 'when page and limit are provided' do
        params.merge!({ page: 2, limit: 1 })
        paginated_records = subject.send(:paginate, Tour.all)
        expect(paginated_records).to contain_exactly(tour2)
      end
    end

    context 'projection' do
      let!(:tour) { create(:tour) }

      it 'returns selected fields of all records that are provided' do
        record = subject.send(:project, Tour.all).map(&:as_json)
        projected_record = { id: tour.id, name: tour.name, key: tour.key }.as_json
        expect(record).to contain_exactly(projected_record)
      end

      it 'returns all fields of all records' do
        params.merge!({ fields: nil })
        records = subject.send(:project, Tour.all)
        expect(records).to contain_exactly(tour)
      end
    end

    context 'range_filter' do
      it 'returns nil when the filter is blank' do
        attribute_name = 'some_attribute'

        result = subject.send(:range_filter, attribute_name)
        expect(result).to be_nil
      end

      it 'returns the correct range filter string when both from and to values are present' do
        params[:filters] = {
          'some_attribute' => {
            'from' => 10,
            'to' => 20
          }
        }
        attribute_name = 'some_attribute'

        result = subject.send(:range_filter, attribute_name)
        expect(result).to eq('some_attribute >= 10 AND some_attribute <= 20')
      end

      it 'returns the correct range filter string when only the from value is present' do
        params[:filters] = {
          'some_attribute' => {
            'from' => 10
          }
        }
        attribute_name = 'some_attribute'

        result = subject.send(:range_filter, attribute_name)
        expect(result).to eq('some_attribute >= 10')
      end

      it 'returns the correct range filter string when only the to value is present' do
        params[:filters] = {
          'some_attribute' => {
            'to' => 20
          }
        }
        attribute_name = 'some_attribute'

        result = subject.send(:range_filter, attribute_name)
        expect(result).to eq('some_attribute <= 20')
      end
    end
  end
end
