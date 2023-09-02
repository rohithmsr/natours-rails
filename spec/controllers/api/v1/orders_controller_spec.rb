describe Api::V1::OrdersController, type: :request do
  let(:parsed_response) { JSON.parse(response.body) }
  let(:tour) { create(:tour) }
  let(:traveller) { create(:traveller, first_name: 'John', last_name: 'Wick') }
  let(:journey) do
    create(
      :journey,
      :with_travellers,
      travellers: [traveller],
      tour: tour
    )
  end

  before do
    allow_any_instance_of(described_class).to receive(:authenticate_traveller!).and_return(true)
    allow_any_instance_of(described_class).to receive(:current_traveller).and_return(traveller)
  end

  describe 'GET /show' do
    let(:order) do
      Order.create!(
        traveller_id: traveller.id,
        journey_id: journey.id,
        amount: 100
      )
    end

    subject do
      lambda do
        get "/api/v1/orders/#{order.id}"
      end
    end

    it 'returns the order details' do
      subject.call
      expect(response.status).to eq(200)
      expect(parsed_response['amount']).to eq('100.0')
      expect(parsed_response['travel_status']).to eq('upcoming')
      expect(parsed_response['payment_done']).to eq(false)
    end
  end

  describe 'POST /create' do
    let(:order_params) do
      {
        journey_id: journey.id,
        amount: 100
      }
    end

    subject do
      lambda do
        post '/api/v1/orders', params: { order: order_params }
      end
    end

    it 'validation fails as amount must be given' do
      order_params.delete(:amount)
      subject.call
      expect(response.status).to eq(422)
      expect(parsed_response['errors']).to contain_exactly('Amount can\'t be blank')
    end

    it 'creates the order' do
      subject.call
      expect(response.status).to eq(201)
      expect(parsed_response['amount']).to eq('100.0')
      expect(parsed_response['travel_status']).to eq('upcoming')
      expect(parsed_response['payment_done']).to eq(false)
    end
  end
end
