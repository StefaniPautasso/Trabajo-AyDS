def load_content(filename)
  File.read(File.join(__dir__, 'contents', filename))
end

lessons = [
  { 
    lesson_type: 'identify', 
    title: 'Identificación de Asfixia', 
    content_file: 'asfixia_identify.txt', 
    section: Section.find_by(title: 'Asfixia') 
  },
  { 
    lesson_type: 'action', 
    title: 'Acciones para Asfixia', 
    content_file: 'asfixia_action.txt', 
    section: Section.find_by(title: 'Asfixia')
  },
  { 
    lesson_type: 'preventive', 
    title: 'Prevención de Asfixia', 
    content_file: 'asfixia_preventive.txt', 
    section: Section.find_by(title: 'Asfixia')
  },
  { 
    lesson_type: 'identify', 
    title: 'Identificación de Quemaduras', 
    content_file: 'quemaduras_identify.txt', 
    section: Section.find_by(title: 'Quemaduras')
  },
  { 
    lesson_type: 'action', 
    title: 'Acciones para Quemaduras', 
    content_file: 'quemaduras_action.txt', 
    section: Section.find_by(title: 'Quemaduras')
  },
  { 
    lesson_type: 'preventive', 
    title: 'Prevención de Quemaduras', 
    content_file: 'quemaduras_preventive.txt', 
    section: Section.find_by(title: 'Quemaduras')
  },
  { 
    lesson_type: 'identify', 
    title: 'Identificación de Ahogamiento', 
    content_file: 'ahogamiento_identify.txt', 
    section: Section.find_by(title: 'Ahogamiento') 
  },
  { 
    lesson_type: 'action', 
    title: 'Acciones para Ahogamiento', 
    content_file: 'ahogamiento_action.txt', 
    section: Section.find_by(title: 'Ahogamiento')
  },
  { 
    lesson_type: 'preventive', 
    title: 'Prevención de Ahogamiento', 
    content_file: 'ahogamiento_preventive.txt', 
    section: Section.find_by(title: 'Ahogamiento') 
  },
  { 
    lesson_type: 'identify', 
    title: 'Identificación de Envenenamiento', 
    content_file: 'envenenamiento_identify.txt', 
    section: Section.find_by(title: 'Envenenamiento')
  },
  { 
    lesson_type: 'action', 
    title: 'Acciones para Envenenamiento', 
    content_file: 'envenenamiento_action.txt', 
    section: Section.find_by(title: 'Envenenamiento')
  },
  { 
    lesson_type: 'preventive', 
    title: 'Prevención de Envenenamiento', 
    content_file: 'envenenamiento_preventive.txt', 
    section: Section.find_by(title: 'Envenenamiento')
  },
  { 
    lesson_type: 'identify', 
    title: 'Identificación de Convulsión', 
    content_file: 'convulsion_identify.txt', 
    section: Section.find_by(title: 'Convulsión')
  },
  { 
    lesson_type: 'action', 
    title: 'Acciones para Convulsión', 
    content_file: 'convulsion_action.txt', 
    section: Section.find_by(title: 'Convulsión')
  },
  { 
    lesson_type: 'preventive', 
    title: 'Prevención de Convulsión', 
    content_file: 'convulsion_preventive.txt', 
    section: Section.find_by(title: 'Convulsión')
  },
  { 
    lesson_type: 'identify', 
    title: 'Identificación de Fracturas, Esguinces y Desgarros', 
    content_file: 'fracturas_esguinces_y_desgarros_identify.txt', 
    section: Section.find_by(title: 'Fracturas, Esguinces y Desgarros')
  },
  { 
    lesson_type: 'action', 
    title: 'Acciones para Fracturas, Esguinces y Desgarros', 
    content_file: 'fracturas_esguinces_y_desgarros_action.txt', 
    section: Section.find_by(title: 'Fracturas, Esguinces y Desgarros')
  },
  { 
    lesson_type: 'preventive', 
    title: 'Prevención de Fracturas, Esguinces y Desgarros', 
    content_file: 'fracturas_esguinces_y_desgarros_preventive.txt', 
    section: Section.find_by(title: 'Fracturas, Esguinces y Desgarros')
  },
  { 
    lesson_type: 'identify', 
    title: 'Identificación de Hemorragias', 
    content_file: 'hemorragias_identify.txt', 
    section: Section.find_by(title: 'Hemorragias')
  },
  { 
    lesson_type: 'action', 
    title: 'Acciones para Hemorragias', 
    content_file: 'hemorragias_action.txt', 
    section: Section.find_by(title: 'Hemorragias') 
  },
  { 
    lesson_type: 'preventive', 
    title: 'Prevención de Hemorragias', 
    content_file: 'hemorragias_preventive.txt', 
    section: Section.find_by(title: 'Hemorragias') 
  },
  { 
    lesson_type: 'identify', 
    title: 'Identificación de Mordeduras y Picaduras de Insectos', 
    content_file: 'mordeduras_y_picaduras_de_insectos_identify.txt', 
    section: Section.find_by(title: 'Mordeduras y Picaduras de Insectos')
  },
  { 
    lesson_type: 'action', 
    title: 'Acciones para Mordeduras y Picaduras de Insectos', 
    content_file: 'mordeduras_y_picaduras_de_insectos_action.txt', 
    section: Section.find_by(title: 'Mordeduras y Picaduras de Insectos')
  },
  { 
    lesson_type: 'preventive', 
    title: 'Prevención de Mordeduras y Picaduras de Insectos', 
    content_file: 'mordeduras_y_picaduras_de_insectos_preventive.txt', 
    section: Section.find_by(title: 'Mordeduras y Picaduras de Insectos')
  },
  { 
    lesson_type: 'identify', 
    title: 'Identificación de Shock', 
    content_file: 'shock_identify.txt', 
    section: Section.find_by(title: 'Shock')
  },
  { 
    lesson_type: 'action', 
    title: 'Acciones para Shock', 
    content_file: 'shock_action.txt', 
    section: Section.find_by(title: 'Shock') 
  },
  { 
    lesson_type: 'preventive', 
    title: 'Prevención de Shock', 
    content_file: 'shock_preventive.txt', 
    section: Section.find_by(title: 'Shock')
  }
]

lessons.each do |lesson_attributes|
    Lesson.find_or_create_by!(title: lesson_attributes[:title], section: lesson_attributes[:section]) do |lesson|
    lesson.lesson_type = lesson_attributes[:lesson_type]
    lesson.content = load_content(lesson_attributes[:content_file])
  end
end
