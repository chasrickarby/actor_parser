# Declare some variables to be used throughout execution
file = ARGV[0]
firstnames = {}
lastnames = {}
wholenames = {}
common_firstnames = {}
common_lastnames = {}
unique_names = []
modified_names = []
N_NAMES = 25


IO.foreach(file).lazy.reject{ |l| l[0..3] == "    " }.each do |line|
  wholename = line.split(" --")[0]
  lastname, firstname = wholename.split(', ')

  # Verify that the name is valid - which means the names contain only uppercase and lowercase letters
  # This means names like O'Connor are invalid.
  next if firstname == nil || lastname == nil || firstname[/[a-zA-Z]+/] != firstname || lastname[/[a-zA-Z]+/] != lastname

  # Unique first names
  firstnames[firstname] = firstnames[firstname].nil? ? 1 : 1 + firstnames[firstname]

  # Unique last names
  lastnames[lastname] = lastnames[lastname].nil? ? 1 : 1 + lastnames[lastname]

  # Unique whole names
  wholenames[wholename] = wholenames[wholename].nil? ? 1 : 1 + wholenames[wholename]

  # Most common first names
  common_firstnames = handle_common_names(common_firstnames, firstnames, firstname)

  # Most common last names
  common_lastnames = handle_common_names(common_lastnames, lastnames, lastname)

  # First N_NAMES Unique Names
  if unique_names.count != N_NAMES
    if firstnames[firstname] == 1 && lastnames[lastname] == 1
      # Both the first and last name are unique. Add.
      unique_names << wholename
    elsif firstnames[firstname] >  1 || lastnames[lastname] > 1
      # Either the first or last name is not unique: remove
      unique_names = unique_names.reject do |x|
        x_last, x_first = x.split(', ')
        next true if x_last == lastname
        next true if x_first == firstname
        next
      end
    end
  elsif unique_names.count == N_NAMES && modified_names.count ==0
    modified_names = get_modified_names(unique_names)
  end
end


# Print results with some extra spaces
puts "Unique firstnames: #{firstnames.count}\n\n"
puts "Unique lastnames: #{lastnames.count}\n\n"
puts "Uniuqe wholenames: #{wholenames.count}\n\n"
puts "Most common firstnames: #{common_firstnames}\n\n"
puts "Most common lastnames: #{common_lastnames}\n\n"
puts "#{N_NAMES} first unique names: #{unique_names}\n\n"
puts "#{N_NAMES} modified names: #{modified_names}\n\n"

# Include some helper methods
BEGIN {
  def handle_common_names(common_names, names, name)
    if common_names.count < 10
      common_names[name.to_s] = names[name]
      common_names = common_names.sort_by {|k, v| -v}.to_h
    elsif common_names[common_names.keys.last] < names[name]
      unless common_names[name].nil?
        common_names[name] = names[name]
      else
        common_names.delete(common_names.keys.last)
        common_names[name] = names[name]
      end
      common_names = common_names.sort_by {|k, v| -v}.to_h
    end
    return common_names
  end

  def get_modified_names(unique_names)
    l_names = []
    f_names = []
    unique_names.each do |name|
      l_names << name.split(', ')[0]
      f_names << name.split(', ')[1]
    end
    mod_names = []
    N_NAMES.times do |i|
      l_name_index = i - 1 >= 0 ? i - 1 : N_NAMES - 1
      mod_names << [l_names[i], f_names[l_name_index]].join(", ")
    end
    return mod_names
  end
}
