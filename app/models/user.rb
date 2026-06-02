class User < ApplicationRecord
  belongs_to :store, optional: true

  before_validation :set_default_store, on: :create

  has_many :posts, dependent: :destroy
  has_many :reads, dependent: :destroy
  has_many :read_posts, through: :reads, source: :post

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :nickname, presence: true, length: { maximum: 20 }

  private

  def set_default_store
    self.store ||= Store.find_or_create_by!(store_code: "default") do |store|
      store.name = "デフォルト店舗"
    end
  end
end
