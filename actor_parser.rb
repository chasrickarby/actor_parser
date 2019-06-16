file = ARGV[0]
firstnames = {}
lastnames = {}
wholenames = {}
firstname_c = 0
lastname_c = 0
wholename_c = 0
common_firstnames = {}
common_lastnames = {}
unique_names = []


IO.foreach(file).lazy.reject{ |l| l[0..3] == "    " }.each do |line|
  wholename = line.split(" --")[0]
  lastname, firstname = wholename.split(', ')

  # Unique first names

  if firstnames[firstname].nil?
    firstnames[firstname] = 1
    firstname_c += 1
  else
    firstnames[firstname] = 1 + firstnames[firstname]
  end

  # Unique last names

  if lastnames[lastname].nil?
    lastnames[lastname] = 1
    lastname_c += 1
  else
    lastnames[lastname] = 1 + lastnames[lastname]
  end

  # Unique whole names

  if wholenames[wholename].nil?
    wholenames[wholename] = 1
    wholename_c += 1
  else
    wholenames[wholename] = 1 + wholenames[wholename]
  end

  # Most common first names

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

  # Most common last names

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

  # First 25 Unique Names

  unless unique_names.count == 25
    if firstnames[firstname] == 1 && lastnames[lastname] == 1
      # Both the first and last name are unique. Add.
      unique_names << wholename
    elsif firstnames[firstname] > 1 || lastnames[lastname] > 1
      # Either the first or last name is not unique: remove
      unique_names = unique_names.reject do |x|
        x_last, x_first = x.split(', ')
        next true if x_last == lastname
        next true if x_first == firstname
        next
      end
    end
  end
end

puts "Unique firstnames: #{firstname_c}"
puts "Unique lastnames: #{lastname_c}"
puts "Uniuqe wholenames: #{wholename_c}"
puts "Most common firstnames: #{common_firstnames}"
puts "Most common lastnames: #{common_lastnames}"
puts "25 first unique names: #{unique_names}"
