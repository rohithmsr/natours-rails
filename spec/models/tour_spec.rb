describe Tour, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :key }
    it { is_expected.to validate_uniqueness_of :key }

    it { is_expected.to validate_presence_of :name }

    it { is_expected.to validate_presence_of :rating }
    it { is_expected.to validate_numericality_of(:rating).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:rating).is_less_than_or_equal_to(5) }

    it { is_expected.to validate_presence_of :duration }
    it { is_expected.to validate_numericality_of(:duration).is_greater_than_or_equal_to(0) }

    it { is_expected.to validate_presence_of :price }
    it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }

    it { is_expected.to validate_numericality_of(:price_discount).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:price_discount).is_less_than_or_equal_to(100) }

    it { is_expected.to validate_presence_of :difficulty }

    context 'difficulty inclusion' do
      let(:tour) { create(:tour) }

      it 'errors when difficulty is neither easy, medium nor hard' do
        expect do
          tour.update!(difficulty: 'simple')
        end.to raise_error(
          ActiveRecord::RecordInvalid,
          'Validation failed: Difficulty must be one of easy, medium, hard'
        )
      end
    end
  end
end
