class User < ApplicationRecord
  has_many :posts
  has_many :reads, dependent: :destroy
  has_many :read_posts, through: :reads, source: :post
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :nickname, presence: true, length: { maximum: 20 }
end
