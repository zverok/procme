# encoding: utf-8
# ProcMe: DRY and clean blocks for your code
module ProcMe
  def filter(hash)
    lambda do |o|
      hash.all?{|k, v| v === o.send(k)} # rubocop:disable Style/CaseEquality
    end
  end

  alias_method :fltr, :filter

  def set(hash)
    lambda do |o|
      hash.each{|k, v| o.send("#{k}=", v)}
      o
    end
  end

  def call(*methods)
    h = methods.last.is_a?(Hash) ? methods.pop : {}
    hash = Hash[*methods.flat_map{|sym| [sym, []]}].merge(h)

    lambda do |o|
      ProcMe._singularize(hash.map{|k, v| o.send(k, *v)})
    end
  end

  def get(*array)
    lambda do |o|
      ProcMe._singularize(array.map{|v| o.send(*v)})
    end
  end

  # now we can use both include ProcMe & no include approach
  extend self # rubocop:disable Style/ModuleFunction

  def _singularize(arr)
    arr.length == 1 ? arr.first : arr
  end
end
