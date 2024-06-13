sections = [
  { title: 'Asfixia' },
  { title: 'Quemaduras' },
  { title: 'Ahogamiento' },
  { title: 'Envenenamiento' },
  { title: 'Convulsión' },
  { title: 'Fracturas, Esguinces y Desgarros' },
  { title: 'Hemorragias' },
  { title: 'Mordeduras y Picaduras de Insectos' },
  { title: 'Shock' }
]

sections.each do |section_attributes|
  Section.find_or_create_by!(title: section_attributes[:title])
end
