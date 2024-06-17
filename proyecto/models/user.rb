class User < ActiveRecord::Base

  has_many :progresses
  has_many :tests, :through => :progresses
  has_and_belongs_to_many :sections
  has_many :answers
  
  validates :name, presence: true, uniqueness: true, format: { without: /\s/, message: "El nombre de usuario no puede contener espacios en blanco" }
  
  validates :password, presence: true, length: { minimum: 8, message: "La contraseña debe tener por lo menos 8 caracteres" }, format: { without: /\s/, message: "La contraseña no puede contener espacios en blanco" }
  
end

