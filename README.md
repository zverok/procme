# ProcMe

## Install
With Bundler:

```ruby
gem 'procme'
```

in your Gemfile, then `bundle install`.

Or without:
```
gem install procme
```

## Usage

```ruby
# Giving you have
class Person < Struct.new(:name, :age, :gender)
  def greet(who)
    puts "#{name}: Hello, #{who}!"
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

# ProcMe::call(method: args) - bulk call method with arguments:
people.each(&call(greet: 'Ellis'))
# Output:
#   John: Hello, Ellis!
#   Jane: Hello, Ellis!
#   Jake: Hello, Ellis!
#   Judith: Hello, Ellis!
```

## Rationale

Look at symple example

```ruby
people.select{|p| p.gender == 'female'}
people.select(&fltr(gender: 'female'))
```

At a first glance, there's not a very big difference,
even in symbols count (ok, ProcMe version 1 symbol shorter :)

Yet there's one important difference: ProcMe version is
[DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself). It's not
DRY for the sake of DRY, it's for better, cleaner and error-prone code.

Assume you are copying the code while rewriting it:

```ruby
aliens.select{|a| p.gender == 'female'}
#                 ^ bang! It was not DRY enough!

# With ProcMe
aliens.select(&fltr(gender: 'female'))
# just no repeating - no place for errors
```

In fact, the rationale it the same, as it was for inventing `Symbol#to_proc`.

ProcMe is very small and simple, without any monkey-patching of core classes.
Only four methods (`fltr`, `get`, `set`, `call`), which you can include
in any namespace or use without inclusion, for ex:

```ruby
P = ProcMe # to be short

people.select(&P.fltr(gender: 'female'))
```
