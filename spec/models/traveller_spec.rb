describe Traveller, type: :model do
  describe '#validations' do
    it { is_expected.to validate_presence_of :first_name }
    it { is_expected.to validate_presence_of :last_name }
  end

  describe 'status' do
    let(:traveller) { build(:traveller, status: nil) }

    before do
      traveller.save
    end

    it 'sets default status as active before validation on create' do
      expect(traveller.status).to eq('active')
    end

    it 'does not set invalid status values on update' do
      expect do
        traveller.update!(status: 'invalid_value')
      end.to raise_error(
        ArgumentError,
        '\'invalid_value\' is not a valid status'
      )
    end

    it 'set valid status value on update' do
      traveller.update!(status: 'inactive')
      expect(traveller.status).to eq('inactive')
    end
  end

  describe 'password' do
    let(:traveller) { create(:traveller, :active_traveller, :with_avatar, password: password) }

    context 'password has no numbers' do
      let(:password) { 'password' }

      it 'raise error if password has no numbers' do
        expect do
          traveller.save
        end.to raise_error(
          ActiveRecord::RecordInvalid,
          'Validation failed: Password must be at least 6 characters and include one number and one letter.'
        )
      end
    end

    context 'password has no letters' do
      let(:password) { '12345678' }

      it 'raise error if password has no letters' do
        expect do
          traveller.save
        end.to raise_error(
          ActiveRecord::RecordInvalid,
          'Validation failed: Password must be at least 6 characters and include one number and one letter.'
        )
      end
    end

    context 'valid password' do
      let(:password) { 'secure123' }

      it 'does not raise error' do
        expect do
          traveller.save
        end.not_to raise_error
      end
    end
  end
end
