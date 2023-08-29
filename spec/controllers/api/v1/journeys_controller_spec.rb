describe Api::V1::JourneysController, type: :request do
  let(:parsed_response) { JSON.parse(response.body) }

  before do
    allow_any_instance_of(described_class).to receive(:authenticate_traveller!).and_return(true)
  end

  describe 'GET /show' do
    let(:tour) { create(:tour) }
    let(:traveller) { create(:traveller, first_name: 'John', last_name: 'Wick') }
    let(:start_date) { '2023-01-05'.to_date }
    let(:end_date) { '2023-01-07'.to_date }
    let(:journey) do
      create(
        :journey,
        :with_travellers,
        travellers: [traveller],
        start_date: start_date,
        end_date: end_date,
        tour: tour
      )
    end

    subject do
      lambda do
        get "/api/v1/journeys/#{journey.id}"
      end
    end

    it 'returns the journey details' do
      subject.call
      expect(response.status).to eq(200)
      expect(parsed_response['journey']['start_date']).to eq('2023-01-05')
      expect(parsed_response['journey']['end_date']).to eq('2023-01-07')
      expect(parsed_response['journey']['tour_id']).to eq(tour.id)
      expect(parsed_response['travellers']['count']).to eq(1)
      expect(parsed_response['travellers']['data'][0]['first_name']).to eq('John')
      expect(parsed_response['travellers']['data'][0]['last_name']).to eq('Wick')
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

  describe 'POST /assign_travellers' do
    let(:tour) { create(:tour) }
    let(:journey) { create(:journey) }
    let(:traveller1) { create(:traveller) }
    let(:traveller2) { create(:traveller, first_name: 'Bob') }

    let(:params) do
      {
        traveller_ids: [traveller1.id, traveller2.id]
      }
    end

    subject do
      lambda do
        post "/api/v1/journeys/#{journey.id}/assign_travellers", params: params
      end
    end

    context 'travellers are already assigned the journey' do
      let(:journey) do
        create(
          :journey,
          :with_travellers,
          travellers: [traveller1, traveller2],
          tour: tour
        )
      end

      it 'fails with a message when travellers already assigned' do
        subject.call
        expect(response.status).to eq(422)
        expect(parsed_response['message']).to eq('Travellers are already assigned / they do not exist')
      end
    end

    it 'fails with a message when traveller ids not given' do
      params.merge!({ traveller_ids: [] })
      subject.call
      expect(response.status).to eq(422)
      expect(parsed_response['message']).to eq('Travellers are already assigned / they do not exist')
    end

    it 'travellers are assigned successfully' do
      subject.call
      expect(response.status).to eq(201)
      expect(parsed_response['message']).to eq("Travellers successfully assigned to the journey #{journey.id}.")
      expect(parsed_response['assigned_travellers']).to contain_exactly(traveller1.as_json, traveller2.as_json)
    end
  end

  describe 'DELETE /unassign_travellers' do
    let(:tour) { create(:tour) }
    let(:traveller1) { create(:traveller) }
    let(:traveller2) { create(:traveller, first_name: 'Bob') }
    let(:journey) do
      create(
        :journey,
        :with_travellers,
        travellers: [traveller1, traveller2],
        tour: tour
      )
    end

    let(:params) do
      {
        traveller_ids: [traveller1.id, traveller2.id]
      }
    end

    subject do
      lambda do
        delete "/api/v1/journeys/#{journey.id}/unassign_travellers", params: params
      end
    end

    context 'travellers are already assigned the journey' do
      let(:journey) { create(:journey) }

      it 'returns empty list when travellers are unassigned already' do
        subject.call
        expect(response.status).to eq(200)
        expect(parsed_response['message']).to eq("Travellers successfully unassigned from the journey #{journey.id}.")
        expect(parsed_response['unassigned_travellers']).to be_empty
      end
    end

    it 'travellers are unassigned successfully' do
      subject.call
      expect(response.status).to eq(200)
      expect(parsed_response['message']).to eq("Travellers successfully unassigned from the journey #{journey.id}.")
      expect(parsed_response['unassigned_travellers']).to contain_exactly(traveller1.as_json, traveller2.as_json)
    end
  end
end
