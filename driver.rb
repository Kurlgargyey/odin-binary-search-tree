# frozen_string_literal: true

require './lib/binary_search_tree'

array = (Array.new(15) { rand(1..100) })
tree = Tree.new(array)
puts tree
puts 'Balanced?'
puts tree.balanced?
puts 'Level order:'
p tree.level_order
puts 'Preorder:'
p tree.preorder
puts 'Postorder:'
p tree.postorder
puts 'Inorder:'
p tree.inorder

(101..110).each { |i| tree.insert(i) }

puts tree

puts 'Balanced?'
puts tree.balanced?
puts 'Rebalance'
puts tree.rebalance
puts 'Balanced?'
puts tree.balanced?

puts 'Level order:'
p tree.level_order
puts 'Preorder:'
p tree.preorder
puts 'Postorder:'
p tree.postorder
puts 'Inorder:'
p tree.inorder

(101..110).each { |i| tree.delete(i) }

puts tree
puts 'Balanced?'
puts tree.balanced?
