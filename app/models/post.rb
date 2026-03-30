class Post < ApplicationRecord
  belongs_to :user
  has_many :reads, dependent: :destroy
  has_many :read_users, through: :reads, source: :user

  enum post_type: {
  notice: 0,
  arrival: 1,
  claim: 2,
  customer_service: 3
  }

  validates :title, presence: true
  validates :content, presence: true
  validates :post_type, presence: true

  def unread_users
    User.where.not(id: read_users.pluck(:id) + [user_id])
  end

  def unread_count
    unread_users.count
  end

  def post_type_label
    case post_type
    when "notice" then "連絡事項"
    when "arrival" then "入荷情報"
    when "claim" then "クレーム対応"
    when "customer_service" then "接客メモ"
    end
  end
end