# frozen_string_literal: true

require './lib/binary_search_tree'

array = (Array.new(15) { rand(1..100) })
tree = Tree.new(array)
puts tree
puts tree.balanced?
p tree.level_order
p tree.preorder
p tree.postorder
p tree.inorder

(101..110).each { |i| tree.insert(i) }

puts tree

puts tree.balanced?
puts tree.rebalance
puts tree.balanced?

p tree.level_order
p tree.preorder
p tree.postorder
p tree.inorder
