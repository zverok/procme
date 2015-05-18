# encoding: utf-8

# ProcMe is DRY and clean blocks for your code.
#
# It provides four methods:
#
# {#fltr} - checks object attribute values
#  
#   ['test', 'me', 'please'].select(&fltr(length: 4))
#   # => ['test']
#
# {#get} - get object attribute values
# 
#   ['test', 'me', 'please'].map(&get(:upcase, :length))
#   # => [['TEST', 4], ['ME', 2'], ['PLEASE', 6]]
#
# {#call} - call methods on object
#
#   ['test', 'me', 'please'].map(&call(gsub: ['e', '*']))
#   # => ['t*st', 'm*', 'pl*as*']
#
# {#set} - set object attribute values
# 
#   S = Struct.new(:name)
#   arr = [S.new('test'), S.new('me')]
#   arr.each(&set(name: 'please'))
#   arr # => [#<struct S name="please">, #<struct S name="please">]
# 
# You can use the module as is:
#
#   ['test', 'me', 'please'].select(&ProcMe.fltr(length: 4))
#
# or include it and then use:
#
#   include ProcMe
#
#   ['test', 'me', 'please'].select(&fltr(length: 4))
#
#
module ProcMe
  # Constructs block, able to check objects attribute values
  #
  # @param attrs [Hash] hash of !{attribute name => value}
  # @return [Proc] block accepting any object and returning +true+ or
  #   +false+
  #
  # Use it like this:
  #
  #   some_array.select(&fltr(attr: value, other_attr: other_value))
  #
  # values are checked with +#===+ method, so you can do something like:
  #
  #   ['some', 'strings'].select(&fltr(length: 3..5)) # => ['some']
  #
  # or like this:
  #
  #   ['other', 'strings'].select(&fltr(upcase: /^S/)) # => ['strings']
  #
  # This approach has one gotcha:
  #
  #   # wrong
  #   ['some', 'strings'].select(&fltr(class: String)) # => []
  #
  #   # right
  #   ['some', 'strings'].select(&fltr(itself: String)) # => ['some', 'strings']
  #
  def filter(attrs)
    lambda do |o|
      hash.all?{|k, v| v === o.send(k)} # rubocop:disable Style/CaseEquality
    end
  end

  alias_method :fltr, :filter

  # Constructs block, able to set objects attribute values
  #
  # @param attrs [Hash] hash of !{attribute name => value}
  # @return [Proc] block, accepting any object and returning it
  #
  # Use it like this:
  #
  #   some_array.each(&set(attr: value))
  #
  def set(attrs)
    lambda do |o|
      attrs.each{|k, v| o.send("#{k}=", v)}
      o
    end
  end

  # Constructs block, able to call methods on object
  #
  # @param methods list of symbols or  !{method => args} pairs
  # @return [Proc] block, accepting any object and returning results of
  #   sending methods to it.
  #
  # Use it like this:
  #
  #   some_array.each(&call(:method, other_method: [args]))
  #
  # If you call only one method, block will return just a result of call
  # for each object:
  #
  #   ['test', 'me'].map(&call(sub: ['e', '*'])) # => ['t*st', 'm*']
  #
  # If you call several methods, it would be array of results for each
  # object:
  #
  #   ['test', 'me'].map(&call(sub: ['e', '*'], index: 'e'))
  #   # => [['t*st', 2], ['m*', 2]]
  #
  # The latter example also shows that +#call+ sends each method to object
  # itself, not the result of previous method call.
  #
  def call(*methods)
    h = methods.last.is_a?(Hash) ? methods.pop : {}
    hash = Hash[*methods.flat_map{|sym| [sym, []]}].merge(h)

    lambda do |o|
      ProcMe._singularize(hash.map{|k, v| o.send(k, *v)})
    end
  end

  # Constructs block, able to receive attribute values from object
  #
  # @param attrs list of symbols
  # @return [Proc] block, accepting any object and returning its attr
  #   values.
  #
  # Use it like this:
  #
  #   some_array.map(&get(:attr, :other))
  #
  # Extremely useful for sorting:
  #
  #   ['John', 'Alice', 'jane'].sort_by(&get(:length, :downcase)
  #   # => ['jane', 'John', 'Alice']
  #
  # As with {#call}, `#get` returns array of results for several methods
  # and one result for only one method (with is not very useful anyways,
  # as `map(&get(:length))` is a full equivalent of `map(&:length)`).
  #
  def get(*attrs)
    lambda do |o|
      ProcMe._singularize(attrs.map{|v| o.send(*v)})
    end
  end

  # now we can use both include ProcMe & no include approach
  extend self # rubocop:disable Style/ModuleFunction

  # @private
  def _singularize(arr)
    arr.length == 1 ? arr.first : arr
  end
end
