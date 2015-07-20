class Library < ActiveRecord::Base
  has_many :books, dependent: :destroy

  validates :name, presence: true, length: { minimum: 4 }, uniqueness: true
  validates :late_fee, presence: true, numericality: { integer_only: true }
  validates :capacity, numericality: { integer_only: true, greater_than_or_equal_to: 1000 }
end
