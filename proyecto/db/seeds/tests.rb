tests = [
  { title: 'Test de Asfixia', section: Section.find_by(title: 'Asfixia') },
  { title: 'Test de Quemaduras', section: Section.find_by(title: 'Quemaduras') },
  { title: 'Test de Ahogamiento', section: Section.find_by(title: 'Ahogamiento') },
  { title: 'Test de Envenenamiento', section: Section.find_by(title: 'Envenenamiento') },
  { title: 'Test de Convulsión', section: Section.find_by(title: 'Convulsión') },
  { title: 'Test de Fracturas, Esguinces y Desgarros', section: Section.find_by(title: 'Fracturas, Esguinces y Desgarros') },
  { title: 'Test de Hemorragias', section: Section.find_by(title: 'Hemorragias') },
  { title: 'Test de Mordeduras y Picaduras de Insectos', section: Section.find_by(title: 'Mordeduras y Picaduras de Insectos') },
  { title: 'Test de Shock', section: Section.find_by(title: 'Shock') }
]

tests.each do |test_attributes|
    Test.find_or_create_by!(title: test_attributes[:title]) do |test|
    test.section = test_attributes[:section]
  end
end

