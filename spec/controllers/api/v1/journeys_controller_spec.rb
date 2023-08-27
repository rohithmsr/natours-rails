describe Api::V1::JourneysController, type: :request do
  let(:parsed_response) { JSON.parse(response.body) }

  before do
    allow_any_instance_of(described_class).to receive(:authenticate_traveller!).and_return(true)
  end

  describe 'GET /show' do
    let(:tour) { create(:tour) }
    let(:start_date) { '2023-01-05'.to_date }
    let(:end_date) { '2023-01-07'.to_date }
    let(:journey) { create(:journey, start_date: start_date, end_date: end_date, tour: tour) }

    subject do
      lambda do
        get "/api/v1/journeys/#{journey.id}"
      end
    end

    it 'returns the journey details' do
      subject.call
      expect(response.status).to eq(200)
      expect(parsed_response['start_date']).to eq('2023-01-05')
      expect(parsed_response['end_date']).to eq('2023-01-07')
      expect(parsed_response['tour_id']).to eq(tour.id)
    end
  end

  describe 'POST /create' do
    let(:start_date) { '2023-01-05' }
    let(:end_date) { '2023-01-07' }
    let(:tour) { create(:tour) }
    let(:journey_params) do
      {
        start_date: start_date,
        end_date: end_date
      }
    end

    subject do
      lambda do
        post '/api/v1/journeys', params: { journey: journey_params }
      end
    end

    it 'validation fails as tour id must be given' do
      subject.call
      expect(response.status).to eq(422)
      expect(parsed_response['errors']).to contain_exactly('Tour must exist')
    end

    it 'creates the journey details' do
      journey_params.merge!({ tour_id: tour.id })
      subject.call
      expect(response.status).to eq(201)
      expect(parsed_response['start_date']).to eq('2023-01-05')
      expect(parsed_response['end_date']).to eq('2023-01-07')
      expect(parsed_response['tour_id']).to eq(tour.id)
    end
  end
end
