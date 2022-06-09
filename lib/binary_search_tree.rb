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
    data.to_s
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

    # this loop finds the correct parent node for the inserted value and saves it to prev
    until temp.nil?
      if node > temp # if the inserted value is greater, look to the right
        prev = temp
        temp = temp.right
      else # if the inserted value is lesser, look to the left
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
      # if there are two children, the method finds the closest successor (leftmost element of the
      # left subtree of the right child), overwrites the target node's data with the successor data,
      # and then deletes the successor
      if node.left && node.right
        successor = node.right
        successor = successor.left while successor.left
        node.data = successor.data
        node.right = delete(successor.data, node.right)
      elsif node.right
        return node.right # replaces the node with its right child if it has one
      elsif node.left
        return node.left # replaces the node with its left child if it has one
      else
        return nil # deletes the node if it has no children
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
      # stack up all left children
      until curr.nil?
        stack << curr
        curr = curr.left
      end

      # visit the node, then stack its right child and go again
      curr = stack.pop
      block.call(curr) if block_given?
      seen << curr
      curr = curr.right
    end
    return seen.map(&:data) unless block_given?
  end

  def preorder(&block)
    stack = [root] # start with root on the stack because we wanna pop at the start of each loop
    seen = []
    until stack.empty?
      curr = stack.pop
      seen << curr
      block.call(curr) if block_given?
      # stack up right first here so that it gets popped last
      stack << curr.right if curr.right && seen.none?(curr.right)
      stack << curr.left if curr.left && seen.none?(curr.left)
    end
    return seen.map(&:data) unless block_given?
  end

  def postorder(&block)
    stack = []
    seen = []
    curr = root
    prev = root # keep track of previously visited node so we know when a node's right child has just been visited

    loop do
      until curr.nil?
        stack << curr
        curr = curr.left
      end
      while curr.nil? && !stack.empty?
        curr = stack[-1]
        if curr.right.nil? || curr.right == prev # we only visit a node once we are done with it's right child
          block.call(curr) if block_given?
          seen << curr
          stack.pop
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

  def height(node)
    return -1 if node.nil? # this returns -1 so that a node with two nil children will have a height of 0 (-1 + 1)

    left_height = height(node.left) + 1
    right_height = height(node.right) + 1

    left_height > right_height ? left_height : right_height # pick tallest subtree to return
  end

  def depth(node)
    height(@root) - height(node)
  end

  def balanced?
    preorder do |node|
      return false if (height(node.left) - height(node.right)).abs > 1
    end
    true
  end

  def rebalance
    array = inorder # grab the array with #inorder so it's already sorted
    @root = nil
    @root = build_tree(array, 0, array.length - 1)
    self
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
