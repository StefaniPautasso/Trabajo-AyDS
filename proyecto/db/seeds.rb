require './server'
require './models/user'
require './models/section'
require './models/lesson'
require './models/test'
require './models/question'
require './models/option'


User.create(username: 'usuario1', password: '123456')
User.create(username: 'usuario2', password: 'password')

# Crear secciones
section = Section.create(title: 'Asfixia', description: 'Aprende sobre la prevención, acción e identificación de la asfixia.')

# Crear lecciones para la sección
section.lessons.create(title: 'Prevención de Asfixia', content: 'Contenido sobre prevención...', lesson_type: 'preventive')
section.lessons.create(title: 'Acción durante la Asfixia', content: 'Contenido sobre cómo actuar...', lesson_type: 'action')
section.lessons.create(title: 'Identificación de Asfixia', content: 'Contenido sobre cómo identificar...', lesson_type: 'identify')

# Crear un test para la sección
test = section.create_test

# Crear preguntas y opciones para el test
question1 = test.questions.create(question_text: '¿Qué hacer si una persona se está asfixiando?')
question1.options.create(option_text: 'Llamar al 911', correct: true)
question1.options.create(option_text: 'Ignorar', correct: false)
question1.options.create(option_text: 'Dar un vaso de agua', correct: false)
question1.options.create(option_text: 'Hacer nada', correct: false)

question2 = test.questions.create(question_text: '¿Cómo prevenir la asfixia en niños?')
question2.options.create(option_text: 'Vigilar mientras comen', correct: true)
question2.options.create(option_text: 'Dejarlos solos', correct: false)
question2.options.create(option_text: 'Darles caramelos duros', correct: false)
question2.options.create(option_text: 'No prestar atención', correct: false)

