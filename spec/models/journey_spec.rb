describe Journey, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :start_date }
    it { is_expected.to validate_presence_of :end_date }

    context 'date range validity' do
      let(:start_date) { '2023-03-03'.to_date }
      let(:journey) { create(:journey, start_date: start_date, end_date: start_date + 10) }

      it 'errors when date range is invalid' do
        expect do
          journey.update!(end_date: start_date - 2)
        end.to raise_error(
          ActiveRecord::RecordInvalid,
          'Validation failed: End date must be greater than or equal to start_date'
        )
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:tour) }
  end
end
