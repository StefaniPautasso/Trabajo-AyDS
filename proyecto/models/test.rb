class Test < ActiveRecord::Base
  has_many :progresses
  has_many :users, :through => :progresses
  belongs_to :section
  has_many :questions
  
  validates :title, presence: true
  validates :section, presence: true
end

