# encoding: utf-8
require_relative '../lib/procme'

# Giving you have
class Person < Struct.new(:name, :age, :gender)
  def greet(who)
    "#{name}: Hello, #{who}!"
  end

  def greet!(who)
    puts greet(name)
  end

  def inspect
    "#<#{name}, #{gender}, #{age}>"
  end
end

people = [
  Person.new('John', 30, 'male'),
  Person.new('Jane', 23, 'female'),
  Person.new('Jake', 48, 'male'),
  Person.new('Judith', 16, 'female')
]

# With ProcMe you can:
include ProcMe

# ProcMe::fltr(method: match) - filter by attribute values/method calls:
p people.select(&fltr(gender: 'female', age: 18...30))
# => [#<Jane, female, 23>]

# ProcMe::get(:method1, :method2) - bulk get attributes
p people.map(&get(:gender, :age))
# => [["male", 30], ["female", 23], ["male", 48], ["female", 16]]

# ...which is really useful when sorting:
p people.sort_by(&get(:gender, :age))
# => [#<Judith, female, 16>, #<Jane, female, 23>, #<John, male, 30>, #<Jake, male, 48>]

# ProcMe::set(attr: value) - bulk set value:
p people.map(&set(gender: 'female'))
# => [#<John, female, 30>, #<Jane, female, 23>, #<Jake, female, 48>, #<Judith, female, 16>]

# ProcMe::call(method: [args]) - bulk call method with arguments:
people.each(&call(greet!: 'Ellis'))
# Output:
#   John: Hello, Ellis!
#   Jane: Hello, Ellis!
#   Jake: Hello, Ellis!
#   Judith: Hello, Ellis!

# also works with #map:
p people.map(&call(greet: 'Ellis'))
# => ["John: Hello, Ellis!", "Jane: Hello, Ellis!", "Jake: Hello, Ellis!", "Judith: Hello, Ellis!"]

# ...and with several arguments:
p people.map(&:name).map(&call(sub: ['J', 'F']))
# => ["Fohn", "Fane", "Fake", "Fudith"]
