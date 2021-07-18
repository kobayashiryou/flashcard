class User < ApplicationRecord
  has_many :questions, dependent: :destroy
end
