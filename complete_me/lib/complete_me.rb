require_relative 'node'
require 'pry'

class CompleteMe

  attr_accessor :root_node

  def initialize
    @root_node = Node.new
    @usage_data = {}
  end

  # insert
  def insert(word)
    node = @root_node
    word.chars.each do |letter|
    unless node.children.key?(letter)
        node.children[letter] = Node.new
      end
      node = node.children[letter]
    end
    node.flag = true
    return node
  end

  def traverse_trie(letters)
    node = @root_node
    letters.chars.each do |letter|
      return nil if !node.children.key?(letter)
      node = node.children[letter]
    end
    return node
  end

  def suggest(prefix)
    # suggestions = []
    # node = traverse_trie(prefix)
    # unweighted_suggestions(node, prefix, suggestions)
    # weighted_suggestions(prefix, suggestions)
    # return suggestions
  end

# take prefix and look at the last letters (node) in prefix
#see if last node in prefix has children
#for each child node of last prefix node, traverse tree until hitting flag, while adding each letter to a variable that is shuffled into the suggestion array
  # def unweighted_suggestions(node, prefix, suggestions)
  #   suggestions << word if node.flag
  #   until !node.has_children?
  #     node.children.keys.each do |letter|
  #       word = prefix + letter
  #       node = node.children[letter]
  #       unweighted_suggestions(node, word, suggestions)
  #     end
  #   end
  #   return suggestions
  # end

  # def weighted_suggestions(prefix, suggestions)
  # end

  def populate(word_set)
    words = word_set.split("\n")
    words.each do |word|
      insert(word)
    end
  end

  def select(input, selected)
    
  end

end
