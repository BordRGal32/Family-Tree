require 'bundler/setup'
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def menu
  puts 'Welcome to the family tree!'
  puts 'What would you like to do?'

  loop do
    puts 'Press a to add a family member.'
    puts 'Press l to list out the family members.'
    puts 'Press m to add who someone is married to.'
    puts 'Press s to see who someone is married to.'
    puts 'Press c to add a child.'
    puts "Press ap to add a parent pair to the tree"
    puts "Press p to add a parent pair to an existing person."
    puts 'Press e to exit.'

    choice = gets.chomp

    case choice
    when 'a'
      add_person
    when 'l'
      list_menu
    when 'm'
      add_marriage
    when 's'
      show_marriage
    when 'c'
      add_child
    when 'ap'
      create_parent
    when 'p'
      add_parent_to_existing_person
    when 'e'
      exit
    end
  end
end

def list_menu
  list
  puts "Enter the name of the person you'd like to view more information on."
  user_input = gets.chomp
  this_person = Person.find_person(user_input)
  person_screen(this_person)
end

def person_screen(this_person)
  if this_person.spouse
    puts "Spouse: #{this_person.spouse.name}"
  end
  parents_menu(this_person)
  grandparents_menu(this_person)
  siblings_menu(this_person)
  children_menu(this_person)
  grandchildren_menu(this_person)

  puts "Birthday: #{this_person.birthday}"
  puts "Press enter to go back to main menu."
  gets
  menu
end

def parents_menu(this_person)
  parents = []
  if this_person.find_parents
    puts "Parents:"
    this_person.find_parents.each do |person|
      puts "\t#{person.name}"
      parents << person
    end
  end
  parents
end

def grandparents_menu(this_person)
  parents = parents_menu(this_person)
  if parents[0].find_parents || parents[1].find_parents
    puts "Grandparents:"
    parents.each do |person|
      found_parents = person.find_parents
      found_parents.each do |person|
        puts "\t#{person.name}"
        parents << person
      end
    end
  end
  parents
end

def siblings_menu(this_person)
  if this_person.find_siblings
    siblings = []
    puts "Siblings:"
    this_person.find_siblings.each do |person|
      puts "\t#{person.name}"
      siblings << person
    end
  end
  siblings
end

def children_menu(this_person)
  children = []
  if this_person.find_children
    puts "Children:"
    this_person.find_children.each do |person|
      puts "\t#{person.name}"
      children << person
    end
  end
  children
end

def grandchildren_menu(this_person)
  if children[0].find_children || children[1].find_children
    puts "Grandchildren:"
    this_person.find_children.each do |person|
      puts "\t#{person.name}"
      children << person
    end
  end
end

def add_person
  puts 'What is the name of the family member?'
  name = gets.chomp
  puts "What is #{name}'s gender (m/f)?"
  gender = gets.chomp
  puts "What is #{name}'s birthday?"
  birthday = gets.chomp
  Person.create(name: name, gender: gender, birthday: birthday)
  puts name + " was added to the family tree.\n\n"
end

def create_parent
  list
  puts "to create a parent pair please select two parents"
  parent1 = find_person
  parent2 = find_person
  Parent.create(parent_one_id: parent1.id, parent_two_id: parent2.id)
end

def update_parent
  if Parent.all[0] == nil
    puts "their are no parent pairs in the family tree. Please add a parent pair"
    create_parent
  else
    puts "enter the list number to select existing parents, type 'add' to add new parents"
    list_parents
    choice = gets.chomp
    case choice
    when 'add'
      parents = create_parent
    else
      parents = Parent.all[choice.to_i-1]
    end
  end
  parents
end

def add_parent_to_existing_person
  puts "too add a parent pair to a person"
  list
  target_person = find_person
  parents = update_parent
  target_person.update(parent_id: parents.id)
end

def add_marriage
  list
  puts 'What is the number of the first spouse?'
  spouse1 = Person.find(gets.chomp)
  puts 'What is the number of the second spouse?'
  spouse2 = Person.find(gets.chomp)
  spouse1.update(spouse_id: spouse2.id)
  puts spouse1.name + " is now married to " + spouse2.name + "."
end

def add_child
  puts "to add a child to the family tree you must select the childs parents"
  parents = update_parent
  puts "What is the child's name?"
  child_name = gets.chomp
  puts "What is #{child_name}'s gender (m/f)?"
  child_gender = gets.chomp
  puts "What is #{child_name}'s birthday?"
  child_birthday = gets.chomp
  new_person = Person.create(name: child_name, parent_id: parents.id, gender: child_gender, birthday: child_birthday)
  puts "#{new_person.name} has been added to the family tree."
end

def find_person
  puts "please enter the name of the person you are looking for"
  person_name = gets.chomp
  Person.find_person(person_name)
end

def list
  puts 'Here are all your relatives:'
  people = Person.all
  people.each do |person|
    puts person.id.to_s + " " + person.name
  end
  puts "\n"
end

def list_parents
  puts "Here are all of your parent pairs:"
  Parent.all.each_with_index do |parent, index|
    parent_one = Person.find(parent.parent_one_id)
    parent_two = Person.find(parent.parent_two_id)
    puts "#{index + 1}: #{parent_one.name}, #{parent_two.name}"
  end
end

def show_marriage
  list
  puts "Enter the number of the relative and I'll show you who they're married to."
  person = Person.find(gets.chomp)
  spouse = Person.find(person.spouse_id)
  puts person.name + " is married to " + spouse.name + "."
end

menu
