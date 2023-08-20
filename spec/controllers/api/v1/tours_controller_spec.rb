describe Api::V1::ToursController, type: :request do
  let(:parsed_response) { JSON.parse(response.body) }

  before do
    allow_any_instance_of(described_class).to receive(:authenticate_traveller!).and_return(true)
  end

  describe 'GET /index' do
    let!(:tour1) { create(:tour, :easier_tour) }
    let!(:tour2) { create(:tour, :harder_tour) }
    let!(:tour3) { create(:tour) }

    subject do
      lambda do
        get '/api/v1/tours'
      end
    end

    context 'returns all tours' do
      it 'gets tour data' do
        subject.call
        expect(response.status).to eq(200)
        expect(parsed_response['result_count']).to eq(3)
      end
    end
  end

  describe 'GET /show' do
    let!(:tour) { create(:tour, :easier_tour, :tour_with_description) }

    subject do
      lambda do
        get "/api/v1/tours/#{tour.id}"
      end
    end

    context 'searches a tour by id' do
      it 'gets tour data' do
        subject.call
        expect(response.status).to eq(200)
        expect(parsed_response['difficulty']).to eq('easy')
      end
    end
  end

  describe 'POST /create' do
    let(:tour_params) { attributes_for(:tour, :easier_tour) }

    subject do
      lambda do
        post '/api/v1/tours', params: { tour: tour_params }
      end
    end

    context 'returns 422' do
      it 'when presence validation fails' do
        tour_params['name'] = nil
        tour_params['key'] = nil
        subject.call
        expect(response.status).to eq(422)
        expect(parsed_response['errors']).to contain_exactly("Name can't be blank", "Key can't be blank")
      end

      it 'difficulty is not valid' do
        tour_params['difficulty'] = 'tough'
        subject.call
        expect(response.status).to eq(422)
        expect(parsed_response['errors']).to contain_exactly('Difficulty must be one of easy, medium, hard')
      end

      it 'rating greater than 5' do
        tour_params['rating'] = 6.7
        subject.call
        expect(response.status).to eq(422)
        expect(parsed_response['errors']).to contain_exactly('Rating must be less than or equal to 5')
      end

      it 'rating lesser than 0' do
        tour_params['rating'] = -1.2
        subject.call
        expect(response.status).to eq(422)
        expect(parsed_response['errors']).to contain_exactly('Rating must be greater than or equal to 0')
      end
    end

    it 'creates a tour' do
      subject.call
      expect(response.status).to eq(201)
      expect(parsed_response['name']).to eq('Easy Tour')
      expect(parsed_response['key']).to eq('easy_tour')
      expect(parsed_response['rating']).to eq(3.5)
      expect(parsed_response['duration']).to eq(5)
      expect(parsed_response['difficulty']).to eq('easy')
      expect(parsed_response['price']).to eq(Float('1000.0').to_s)
    end
  end

  describe 'DELETE /destroy' do
    let(:tour) { create(:tour) }

    subject do
      lambda do
        delete "/api/v1/tours/#{tour.id}"
      end
    end

    it 'deletes a tour with id' do
      subject.call
      expect(response.status).to eq(204)
    end
  end

  describe 'Record Not Found' do
    it 'returns 404 when trying to access a tour that is not present' do
      get '/api/v1/tours/0'
      expect(response.status).to eq(404)
      expect(parsed_response['error']).to eq("Couldn't find Tour with 'id'=0")
    end

    it 'returns 404 when trying to delete a tour that is not present' do
      delete '/api/v1/tours/0'
      expect(response.status).to eq(404)
      expect(parsed_response['error']).to eq("Couldn't find Tour with 'id'=0")
    end
  end
end
