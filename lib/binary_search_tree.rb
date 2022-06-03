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

  def to_s
    "#{data.to_s}\n"
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
    if root.nil?
      @root = node
      return
    end

    prev = nil
    temp = root
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

  def delete(value, node = @root)
    return nil if node.nil?

    if node.data == value
      if node.left && node.right
        curr = node.right
        curr = curr.left while curr.left
        node.data = curr.data
        node.right = delete(node.data, node.right)
      elsif node.right
        return node.right
      elsif node.left
        return node.left
      else
        return nil
      end
    elsif value > node.data
      node.right = delete(value, node.right)
    else
      node.left = delete(value, node.left)
    end

    node
  end

  def find(value)
    temp = root
    until temp.nil? || temp.data == value
      temp = if value > temp.data
               temp.right
             else
               temp.left
             end
    end
    return nil if temp.nil?

    temp
  end

  def to_s
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
    insert(arr[mid])
    build_tree(arr, startpoint, mid - 1)
    build_tree(arr, mid + 1, endpoint)
  end
end

array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
tree = Tree.new(array)
p array
puts tree
puts tree.find(9)

tree.delete(13)
puts "Deleted 13"
puts tree

tree.delete(12)
puts "Deleted 12"
puts tree