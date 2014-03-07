# -*- coding: utf-8 -*-
require 'tsort'


class Hash
  include TSort
  alias tsort_each_node each_key
  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end
end

class Jobs < Hash
  attr_reader :result
  def initialize(str)
    #p str
    @structure = Hash[str.split("\n").collect{|x|
                        s= x.strip.split("=>")
                        a=s[0].strip.to_sym
                        if s[1]
                          b= [ s[1].delete('[]').strip.to_sym]
                        end
                        [ a,
                          if b == nil
                            []
                          else
                            b
                          end
                        ]
                      }]
    #p @structure
    test_self_dependency
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
  def test_self_dependency
    @structure.each do |key, value|
      value = [] unless value
      value.each do |v|
        raise "jobs can’t depend on themselves" if key == v
      end
    end
  end
end
