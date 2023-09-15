class User < ApplicationRecord
  has_secure_password validations: false
  has_secure_token :auth_token, length: 30

  validates :phone_number, uniqueness: true, presence: true,
            format: { with: /[0-9]{6}/,
                      message: 'Please provide valid phone number'}
  validates :email, uniqueness: true, presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP,
                      message: 'Please provide valid email' }
  validates :first_name, :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
