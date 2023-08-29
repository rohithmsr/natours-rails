RSpec.describe TravelAssignment, type: :model do
  describe '#associations' do
    it { is_expected.to belong_to(:traveller) }
    it { is_expected.to belong_to(:journey) }
  end

  describe 'uniqueness validations' do
    let(:journey) { create(:journey) }
    let(:traveller) { create(:traveller) }

    subject { TravelAssignment.new(traveller_id: traveller.id, journey_id: journey.id) }

    it { is_expected.to validate_uniqueness_of(:traveller_id).scoped_to(:journey_id) }
  end
end
