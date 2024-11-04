require 'json'

report = JSON.parse(File.read('rubocop_report.json'))
offenses = report['files'].flat_map { |file| file['offenses'] }

offense_counts = Hash.new(0)
offenses.each do |offense|
  offense_counts[offense['cop_name']] += 1
end

offense_counts.each do |cop_name, count|
  puts "#{cop_name}: #{count}"
end
