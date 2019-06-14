file = ARGV[0]
firstnames = {}
lastnames = {}
wholenames = {}
firstname_c = 0
lastname_c = 0
wholename_c = 0
common_firstnames = {}
common_lastnames = {}


IO.foreach(file).lazy.reject{ |l| l[0..3] == "    " }.each do |line|
  wholename = line.split(" --")[0]
  lastname, firstname = wholename.split(', ')

  if firstnames[firstname].nil?
    firstnames[firstname] = 1
    firstname_c += 1
  else
    firstnames[firstname] = 1 + firstnames[firstname]
  end

  if lastnames[lastname].nil?
    lastnames[lastname] = 1
    lastname_c += 1
  else
    lastnames[lastname] = 1 + lastnames[lastname]
  end

  if wholenames[wholename].nil?
    wholenames[wholename] = 1
    wholename_c += 1
  else
    wholenames[wholename] = 1 + wholenames[wholename]
  end

  if common_firstnames.count < 10
    common_firstnames[firstname.to_s] = firstnames[firstname]
    common_firstnames = common_firstnames.sort_by {|k, v| -v}.to_h
  elsif common_firstnames[common_firstnames.keys.last] < firstnames[firstname]
    unless common_firstnames[firstname].nil?
      common_firstnames[firstname] = firstnames[firstname]
    else
      common_firstnames.delete(common_firstnames.keys.last)
      common_firstnames[firstname] = firstnames[firstname]
    end
    common_firstnames = common_firstnames.sort_by {|k, v| -v}.to_h
  end

  if common_lastnames.count < 10
    common_lastnames[lastname.to_s] = lastnames[lastname]
    common_lastnames = common_lastnames.sort_by {|k, v| -v}.to_h
  elsif common_lastnames[common_lastnames.keys.last] < lastnames[lastname]
    unless common_lastnames[lastname].nil?
      common_lastnames[lastname] = lastnames[lastname]
    else
      common_lastnames.delete(common_lastnames.keys.last)
      common_lastnames[lastname] = lastnames[lastname]
    end
    common_lastnames = common_lastnames.sort_by {|k, v| -v}.to_h
  end
end

puts "Unique firstnames: #{firstname_c}"
puts "Unique lastnames: #{lastname_c}"
puts "Uniuqe wholenames: #{wholename_c}"
puts "Most common firstnames: #{common_firstnames}"
puts "Most common lastnames: #{common_lastnames}"
