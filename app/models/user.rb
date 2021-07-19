class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  validates :uid, presence: true
end
