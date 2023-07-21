describe Api::V1::ToursController, type: :request do
  let(:parsed_response) { JSON.parse(response.body) }

  describe 'GET /show' do
    let (:tour) { create(:tour, :easier_tour, :tour_with_description) }

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

  describe 'Record Not Found' do
    it 'returns 404' do
      get '/api/v1/tours/0'
      expect(response.status).to eq(404)
      expect(parsed_response['error']).to eq("Couldn't find Tour with 'id'=0")
    end
  end
end
