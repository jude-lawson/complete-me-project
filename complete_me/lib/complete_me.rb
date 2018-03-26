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
end
