class Message < ApplicationRecord

  belongs_to :user
  belongs_to :room
  has_many :notifications, dependent: :destroy

  validates :message, {presence: true, length: {maximum: 140}}
  
  
end
