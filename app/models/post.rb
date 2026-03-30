class Post < ApplicationRecord
  belongs_to :user

  enum post_type: { study_log: 0, error_log: 1 }
  enum status: { unsolved: 0, solved: 1 }

  validates :title, presence: true
  validates :content, presence: true
  validates :post_type, presence: true
  validates :status, presence: true
end