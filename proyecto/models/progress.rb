class Progress < ActiveRecord::Base
  belongs_to :user
  belongs_to :test

  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :test, presence: true
  validates :user, presence: true

  def calculate_score(test)
    total_questions = test.questions.count
    correct_answers = Answer.joins(:question, :option)
                           .where(user_id: self.user_id, questions: { test_id: test.id }, options: { correct: true })
                           .distinct
                           .count

    self.score = (correct_answers.to_f / total_questions * 100).round(2)
    save
  end
end

