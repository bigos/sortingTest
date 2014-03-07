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
  def initialize(structure)
    @structure=structure
    puts @structure.inspect+'***************'
    test_self_dependency
    sort
    @structure
  end
  def sort
    begin
      puts @structure.tsort.inspect
    rescue Cyclic
      puts 'jobs can’t have circular dependencies'
    end
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
struct = { :a =>[],
  :b =>[:c],
  :c =>[:f],
  :d =>[:a],
  :e =>[],
  :f =>[:b]}
begin
r = Jobs.new(struct)
rescue "jobs can’t have circular dependencies"
  p $!
end

puts 'trying for last error'
struct = ({:a=>[],:b=>[],:c=>[:c]})

Jobs.new(struct)
