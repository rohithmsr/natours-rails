RSpec.describe Api::V1::BaseController, type: :request do
  subject do
    lambda do
      get '/'
    end
  end

  let(:parsed_response) { JSON.parse(response.body) }

  context '#home' do
    it 'returns guest if not logged in' do
      subject.call
      expect(response.status).to eq(200)
      expect(parsed_response['message']).to eq('Hi Guest, Welcome to the Natours API')
    end

    it 'returns traveller name if logged in' do
      allow_any_instance_of(described_class).to receive(:traveller_name).and_return('John Wick')

      subject.call
      expect(response.status).to eq(200)
      expect(parsed_response['message']).to eq('Hi John Wick, Welcome to the Natours API')
    end
  end
end
