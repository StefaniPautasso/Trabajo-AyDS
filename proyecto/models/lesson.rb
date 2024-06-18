class Lesson < ActiveRecord::Base
  belongs_to :section
  
  enum lesson_type: {
    identify: 0,
    action: 1,
    preventive: 2
  }
  
  validates :title, presence: true
  validates :content, presence: true
  validates :lesson_type, presence: true
  validates :section, presence: true
end

