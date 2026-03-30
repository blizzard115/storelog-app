class Store < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :posts, dependent: :destroy

  validates :name, presence: true
  validates :store_code, presence: true, uniqueness: true
end