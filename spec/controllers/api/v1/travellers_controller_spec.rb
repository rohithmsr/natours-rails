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

  describe 'PATCH /deactivate' do
    let!(:traveller) { create(:traveller, :active_traveller) }

    it 'deactivates a traveller account' do
      patch :deactivate, params: { traveller_id: traveller.id }

      expect(response.status).to eq(200)
      expect(parsed_response['status']).to eq('inactive')
    end

    it 'returns error when trying to deactivate already deactivated traveller account' do
      traveller.update!(status: 'inactive')
      patch :deactivate, params: { traveller_id: traveller.id }

      expect(response.status).to eq(422)
      expect(parsed_response['error']).to eq('Traveller Account is already inactive')
    end
  end

  describe 'PATCH /reactivate' do
    let!(:traveller) { create(:traveller, :inactive_traveller) }

    it 'reactivates a traveller account' do
      patch :reactivate, params: { traveller_id: traveller.id }

      expect(response.status).to eq(200)
      expect(parsed_response['status']).to eq('active')
    end

    it 'returns error when trying to reactivate already active traveller account' do
      traveller.update!(status: 'active')
      patch :reactivate, params: { traveller_id: traveller.id }

      expect(response.status).to eq(422)
      expect(parsed_response['error']).to eq('Traveller Account is already active')
    end
  end
end
