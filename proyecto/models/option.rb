# frozen_string_literal: true

# Modelo de una opción de respuesta.
class Option < ActiveRecord::Base
  belongs_to :question
  has_many :answers
  validates :content, presence: true
  validates :question, presence: true
end
