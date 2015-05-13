# encoding: utf-8
module ProcMe
  def filter(hash)
    ->(o){
      hash.all?{|k,v| v === o.send(k)}
    }
  end

  alias_method :fltr, :filter

  def set(hash)
    ->(o){
      hash.each{|k,v| o.send("#{k}=", v)}
      o
    }
  end

  def call(hash)
    ->(o){
      hash.each{|k,v| o.send(k, *v)}
      o
    }
  end

  def get(*array)
    ->(o){
      array.map{|v| o.send(*v)}
    }
  end

  extend self # no we can use both include ProcMe & no include approach
end
