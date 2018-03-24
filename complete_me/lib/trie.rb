require_relative 'node'
require 'pry'

class Trie

  attr_accessor :root_node

  def initialize
    @root_node = Node.new
  end

# insert
def insert(word)
  node = @root_node
  word.chars.map do |letter|
    if !node.children.has_key?(letter)
      node.children[letter] = Node.new
      binding.pry
    end
    node = node.children[letter]
  end
  node.flag = true
  binding.pry
  return
end

end

trie = Trie.new
trie.insert("hello")
