class User < ApplicationRecord
  belongs_to :store, optional: true

  has_many :posts, dependent: :destroy
  has_many :reads, dependent: :destroy
  has_many :read_posts, through: :reads, source: :post

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :nickname, presence: true, length: { maximum: 20 }
end
