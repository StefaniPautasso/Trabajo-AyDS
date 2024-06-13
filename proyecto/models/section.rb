class Section < ActiveRecord::Base
  has_many :lessons
  has_one :test
  has_and_belongs_to_many :users
  
  validates :title, presence: true
end

