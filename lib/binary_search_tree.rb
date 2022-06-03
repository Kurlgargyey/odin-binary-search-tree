# frozen_string_literal: true

class Node
  include Comparable

  attr_accessor :data, :left, :right

  def initialize(data = nil, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  def <=>(other)
    data <=> other.data
  end
end

class Tree
  attr_accessor :root

  def initialize(arr)
    @root = build_tree(arr.sort.uniq, 0, arr.uniq.length - 1)
  end

  def insert(data)
    return if data.nil?

    node = Node.new(data)
    puts "Node data: #{node.data}"
    if root.nil?
      puts "Assigning new root: #{node}"
      @root = node
      return
    end

    prev = nil
    temp = root
    puts "Temp data: #{temp.data}"
    until temp.nil?
      if node > temp
        prev = temp
        temp = temp.right
      else
        prev = temp
        temp = temp.left
      end
    end

    if node > prev
      prev.right = node
    else
      prev.left = node
    end

    root
  end

  def to_s(node = @root)
    pretty_print
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  def build_tree(arr, startpoint, endpoint)
    return root if startpoint > endpoint

    mid = (startpoint + endpoint) / 2
    puts "Inserting #{arr[mid]}"
    insert(arr[mid])
    build_tree(arr, startpoint, mid - 1)
    build_tree(arr, mid + 1, endpoint)
  end
end

array = [0, 523, 5, 8, 11, 60, 9]
tree = Tree.new(array)

puts tree
