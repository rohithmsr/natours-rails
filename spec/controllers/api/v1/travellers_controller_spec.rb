describe Api::V1::TravellersController, type: :controller do
  let(:parsed_response) { JSON.parse(response.body) }

  before do
    allow_any_instance_of(described_class).to receive(:authenticate_traveller!).and_return(true)
  end

  describe 'GET /show' do
    let!(:traveller) { create(:traveller, :active_traveller) }

    context 'searches a traveller by id' do
      it 'gets traveller data' do
        get :show, params: { id: traveller.id }

        expect(response.status).to eq(200)
        expect(parsed_response['status']).to eq('active')
        expect(parsed_response['avatar']).to be_nil
      end
    end
  end
end
