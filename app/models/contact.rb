class Contact < ApplicationRecord

  validates :name, presence: true
  validates :email, presence: true
  validates :phone_number, presence: true
  validates :body, presence: true

end
