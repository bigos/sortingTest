# -*- coding: utf-8 -*-
require 'tsort'

class Hash
  include TSort
  alias tsort_each_node each_key

  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end

  def parse_job_dependencies(str)
    Hash[str.split("\n").collect{|line|
           key, val, *unexpected = line.split("=>")
           raise "malformed data in: #{line.inspect}" unless unexpected.empty?
           key = key.strip.to_sym
           value = []
           if val
             valstr = val.strip.delete('[]')
             raise "one character long job symbols expected" if valstr.size > 1
             value << valsym = valstr.to_sym
             raise "jobs can’t depend on themselves" if key == valsym
           end
           [key, value]
         }]
  end
end

class Jobs < Hash
  attr_reader :result

  def initialize(str)
    #p str
    @structure = parse_job_dependencies(str)
    #p @structure
    @result = ''
    sort
  end

  def sort
    begin
      @structure.tsort.each do |e|
        @result << e.to_s
      end
    rescue TSort::Cyclic
      raise 'jobs can’t have circular dependencies'
    end
  end
end
