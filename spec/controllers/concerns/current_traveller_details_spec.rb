RSpec.describe CurrentTravellerDetails, type: :controller do
  controller(ApplicationController) do
    include CurrentTravellerDetails

    def index
      render plain: traveller_name
    end
  end

  describe '#traveller_name' do
    it 'returns "Guest" when no current_traveller is available' do
      get :index
      expect(response.body).to eq('Guest')
    end

    it 'returns the full name of the current_traveller' do
      let(:traveller) { create(:traveller) }
      allow(controller).to receive(:current_traveller).and_return(traveller)

      get :index
      expect(response.body).to eq('Joel Hicks')
    end
  end
end
