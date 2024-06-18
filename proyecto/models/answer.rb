class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  belongs_to :option
  
  validates :user, presence: true
  validates :question, presence: true
  validates :option, presence: true
  
  def self.save_user_responses(user_id, test, responses)
    questions = test.questions
    where(user_id: user_id, question_id: questions.map(&:id)).destroy_all
    responses.each do |response|
      create(user_id: user_id, question_id: response[:question_id], option_id: response[:option_id])
    end
  end  
end
