class Book < ActiveRecord::Base
  belongs_to :library

  validates :title, presence: true, length: { maximum: 500 }
  validates :author, presence: true, length: { minimum: 5, maximum: 100 }
  validates :pages, numericality: { integer_only: true, greater_than_or_equal_to: 4 }
  validates :isbn, format: { with: /\A[\d]{9}[-][\d|X]\z/, message: 'is not a valid ISBN' }

  def available?
    book = Lend.find_by_book_id(self.id)
    if !book.nil?
      book.due == Date.today ? true : false
    else
      true
    end
  end

end
