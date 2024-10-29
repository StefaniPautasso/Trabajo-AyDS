class Question < ActiveRecord::Base
  belongs_to :test
  has_many :options
  has_many :answers
  
  validates :content, presence: true
  validates :test, presence: true

  def correct_option
    options.find_by(correct: true)
  end

end

