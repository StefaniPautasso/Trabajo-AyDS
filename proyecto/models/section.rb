class Section < ActiveRecord::Base
  has_many :lessons
  has_one :test
end
