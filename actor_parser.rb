file = ARGV[0]
firstnames = {}
lastnames = {}
wholenames = {}
firstname_c = 0
lastname_c = 0
wholename_c = 0
common_firstnames = []
common_lastnames = []


IO.foreach(file).lazy.reject{ |l| l[0..3] == "    " }.first(1000).each do |line|
  wholename = line.split(" --")[0]
  lastname, firstname = wholename.split(', ')

  puts firstnames[firstname]
  if firstnames[firstname].nil?
    firstnames[firstname] = 1
    firstname_c += 1
  else
    firstnames[firstname] = 1 + firstnames[firstname]
  end

  lastnames[lastname].nil? ? lastnames[lastname] = 1 && lastname_c += 1 : lastnames[lastname] += 1
  wholenames[wholename].nil? ? wholenames[wholename] = 1 && wholename_c += 1 : wholenames[wholename] += 1

  if common_firstnames.count < 10
    common_firstnames.push({firstname.to_s => firstnames[firstname]})
  else
    if common_firstnames.last.values.first < firstnames[firstname]
      common_firstnames[0] = {firstname.to_s => firstnames[firstname]}
      common_firstnames = common_firstnames.sort_by { |k| k.values.first }
    end
  end
end

puts "Unique firstnames: #{firstname_c}"
puts "Unique lastnames: #{lastname_c}"
puts "Uniuqe wholenames: #{wholename_c}"
puts "Most common firstnames: #{common_firstnames}"
