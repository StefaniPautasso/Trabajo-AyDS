class User < ActiveRecord::Base
  has_many :progresses
  has_many :tests, :through => :progresses
  has_and_belongs_to_many :sections
  has_many :answers
  
  validates :name, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }
end

