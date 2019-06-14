file = ARGV[0]
firstnames = {}
lastnames = {}
wholenames = {}
firstname_c = 0
lastname_c = 0
wholename_c = 0

IO.foreach(file).lazy.reject{ |l| l[0..3] == "    " }.each do |line|
  wholename = line.split(" --")[0]
  lastname, firstname = wholename.split(', ')
  firstnames[firstname] = true && firstname_c += 1 if firstnames[firstname].nil?
  lastnames[lastname] = true && lastname_c += 1 if lastnames[lastname].nil?
  wholenames[wholename] = true && wholename_c += 1 if wholenames[wholename].nil?
end

puts "Unique firstnames: #{firstname_c}"
puts "Unique lastnames: #{lastname_c}"
puts "Uniuqe wholenames: #{wholename_c}"
