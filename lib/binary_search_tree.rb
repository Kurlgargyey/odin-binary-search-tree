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
    return nil unless other.is_a?(Node)

    data <=> other.data
  end

  def to_s
    "#{data.to_s}"
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
    temp
  end

  def level_order(&block)
    queue = [@root]

    queue.each do |node|
      block.call(node) if block_given?
      queue << node.left if node.left
      queue << node.right if node.right
    end

    return queue.map(&:data) unless block_given?
  end

  def inorder(&block)
    stack = []
    seen = []
    curr = root
    until stack.empty? && curr.nil?
      until curr.nil?
        stack << curr
        curr = curr.left
      end
      next if stack.empty?

      curr = stack.pop
      block.call(curr) if block_given?
      seen << curr
      curr = curr.right
    end
    return seen.map(&:data) unless block_given?
  end

  def preorder(&block)
    stack = []
    seen = []
    stack << root
    until stack.empty?
      curr = stack.pop
      if seen.none?(curr)
        seen << curr
        block.call(curr) if block_given?
      end
      stack << curr.right if curr.right && seen.none?(curr.right)
      stack << curr.left if curr.left && seen.none?(curr.left)
    end
    return seen.map(&:data) unless block_given?
  end

  def postorder(&block)
    stack = []
    seen = []
    curr = root
    prev = root

    loop do
      until curr.nil?
        stack << curr
        curr = curr.left
        p stack.map(&:data)
      end
      while curr.nil? && !stack.empty?
        curr = stack[-1]
        if curr.right.nil? || curr.right == prev
          block.call(curr) if block_given?
          seen << curr
          stack.pop
          p seen.map(&:data)
          prev = curr
          curr = nil
        else
          curr = curr.right
        end
      end
      break if stack.empty?
    end

    return seen.map(&:data) unless block_given?
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

p tree.level_order
p tree.inorder
p tree.preorder
p tree.postorder