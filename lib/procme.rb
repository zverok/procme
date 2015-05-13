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

  def call(hash)
    lambda do |o|
      hash.each{|k, v| o.send(k, *v)}
      o
    end
  end

  def get(*array)
    lambda do |o|
      array.map{|v| o.send(*v)}
    end
  end

  # now we can use both include ProcMe & no include approach
  extend self # rubocop:disable Style/ModuleFunction
end
