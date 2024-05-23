class Question < ActiveRecord::Base
  belongs_to :test
  has_many :options
  
  def correct_option
    options.find_by(correct: true)
  end
end

