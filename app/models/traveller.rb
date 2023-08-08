class Traveller < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, presence: true
  validates :last_name, presence: true
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
end
