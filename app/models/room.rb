class Room < ApplicationRecord
  
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :notifications, dependent: :destroy
  
  #entriesテーブルを経由してusersテーブルにアクセスできる。（room.usersで情報が取れる）
  has_many :users, through: :entries
end
