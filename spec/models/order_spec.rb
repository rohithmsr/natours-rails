describe Order, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :amount }
    it { is_expected.to validate_presence_of :travel_status }
    it do
      is_expected.to define_enum_for(:travel_status)
        .backed_by_column_of_type(:string)
        .with_values(upcoming: 'upcoming', completed: 'completed', cancelled: 'cancelled', absent: 'absent')
    end

    context 'travel_status_for_unpaid' do
      let(:journey) { create(:journey) }
      let(:traveller) { create(:traveller) }

      it 'raises error when marking complete from unpaid order' do
        expect do
          Order.create!(
            travel_status: 'completed',
            payment_done: false,
            traveller_id: traveller.id,
            journey_id: journey.id,
            amount: 100
          )
        end.to raise_error(
          ActiveRecord::RecordInvalid,
          'Validation failed: Travel status cannot be set to \'completed\' without payment'
        )
      end

      it 'does not raise error' do
        expect do
          Order.new(traveller_id: traveller.id, journey_id: journey.id, amount: 100)
        end.not_to raise_error
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:traveller) }
    it { is_expected.to belong_to(:journey) }
  end
end
