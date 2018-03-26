require_relative 'node'
require 'pry'

class CompleteMe

  attr_accessor :root_node

  def initialize
    @root_node = Node.new
  end

  # insert
  def insert(word)
    node = @root_node
    word.chars.map do |letter|
      unless node.children.key?(letter)
        node.children[letter] = Node.new
      end
      node = node.children[letter]
    end
    node.flag = true
  end

  def populate(word_set)
    words = word_set.split("\n")
    words.each do |word|
      insert(word)
    end
  end

  def select(input, selected)
  end

  def suggest(input)
    # call traverse, return word_array
  end

  def traverse(input_string, current_node = @root_node)
    # Instantiate local result_array
    # walk to current letter
      # has word flag
        # call walk_to_root
      # else recurse
    # --walk_to_root(current_node)
      # push letter to word_array
      # walk to upper_node
      # if root
        # return word_array
      # else
        # add letter to word_array
        # recurse
  end
end
