class Traveller < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_validation :set_status, on: :create

  enum status: { active: 'active', inactive: 'inactive' }

  has_many :travel_assignments, dependent: :destroy
  has_many :journeys, through: :travel_assignments

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :status, presence: true
  validate :password_complexity

  def password_complexity
    # https://stackoverflow.com/questions/11992544/validating-password-using-regex
    return if password.blank?
    return if password.match(/^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$/)

    errors.add :password, message: 'must be at least 6 characters and include one number and one letter.'
  end

  def full_name
    "#{first_name} #{last_name}"
  end

private

  def set_status
    self.status = 'active' unless status == 'inactive'
  end
end
