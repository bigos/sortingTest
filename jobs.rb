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
  def initialize(structure)
    @structure=structure
    test_self_dependency
    @result = ''
    sort
  end
  def sort
    begin
      @structure.tsort.each do |e|
        @result << e.to_s
      end
      p 'fffffffffff'+@result
    rescue Cyclic
      puts 'jobs can’t have circular dependencies'
    end
    @result
  end
  def test_self_dependency
    @structure.each do |key, value|
      value.each do |v|
        raise "jobs can’t depend on themselves" if key == v
      end
    end
  end
end

p ({:a=>[]}.tsort)

p ({:a=>[],:b=>[],:c=>[]}.tsort)

p ({:a=>[], :b=>[:c], :c=>[]}.tsort)

p ({ :a =>[],
     :b =>[:c],
     :c =>[:f],
     :d =>[:a],
     :e =>[:b],
     :f =>[]}.tsort)

# p ({:a=>[],:b=>[],:c=>[:c]}.tsort)

# p ({ :a =>[],
#      :b =>[:c],
#      :c =>[:f],
#      :d =>[:a],
#      :e =>[],
#      :f =>[:b]}.tsort)


#############
puts '----------------------'

p Jobs.new({ :a =>[],
     :b =>[:c],
     :c =>[:f],
     :d =>[:a],
     :e =>[:b],
     :f =>[]}).result
puts '//////////////////////'

struct = { :a =>[],
  :b =>[:c],
  :c =>[:f],
  :d =>[:a],
  :e =>[],
  :f =>[:b]}
begin
  p Jobs.new(struct).result
rescue "jobs can’t have circular dependencies"
  p $!
end

puts 'trying for last error'
struct = ({:a=>[],:b=>[],:c=>[:c]})
begin
  p Jobs.new(struct).result
rescue
  p $!
end
