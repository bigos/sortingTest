require 'tsort'


class Hash
  include TSort
  alias tsort_each_node each_key
  def tsort_each_child(node, &block)
    fetch(node).each(&block)
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

p ({:a=>[],:b=>[],:c=>[:c]}.tsort)

p ({ :a =>[],
     :b =>[:c],
     :c =>[:f],
     :d =>[:a],
     :e =>[],
     :f =>[:b]}.tsort)
