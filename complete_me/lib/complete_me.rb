require_relative 'node'
require 'pry'

class CompleteMe

  attr_reader :usage_data
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
    suggestions = []
    node = traverse_trie(prefix)
    sort_suggestions(prefix, unweighted_suggestions(node, prefix, suggestions))
    # weighted_suggestions(prefix, suggestions)
  end

# take prefix and look at the last letters (node) in prefix
#see if last node in prefix has children
#for each child node of last prefix node, traverse tree until hitting flag, while adding each letter to a variable that is shuffled into the suggestion array
  def unweighted_suggestions(node, prefix, suggestions)
    suggestions << prefix if node.flag
    if node.has_children?
      node.children.keys.each do |letter|
        word = prefix 
        word += letter
        suggest_node = node.children[letter]
        unweighted_suggestions(suggest_node, word, suggestions)
      end
    end
    return suggestions
  end

  def sort_suggestions(prefix, suggestions)
    return suggestions if @usage_data[prefix] == nil
    suggestions.sort_by do |word|
      if @usage_data[prefix][word] == nil
        0
      else
        @usage_data[prefix][word]
      end
    end.reverse
  end

  def populate(word_set)
    words = word_set.split("\n")
    words.each do |word|
      insert(word)
    end
  end

  def select(input, selected)
    if @usage_data[input]
      if @usage_data[input][selected]
        @usage_data[input][selected] += 1
      else
        @usage_data[input] = {selected => 1}
      end
    else
      @usage_data = {input => {selected => 1}}
    end
  end
end

