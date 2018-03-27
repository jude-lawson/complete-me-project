require_relative 'node'
require 'pry'

class CompleteMe

  attr_reader :usage_data, :count
  attr_accessor :root_node


  def initialize
    @root_node = Node.new
    @usage_data = {}
    @count = 0
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
    @count += 1
    return node
  end

  def traverse_trie(word)
    node = @root_node
    word.chars.each do |letter|
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
    return [] if node == nil
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

  # if the node does not have any children, just set node.flag to false
  # if the node has children change the node flag to false and delete all children 
  # up to the next flag... do not delete this flag
  def delete(word)
    node = traverse_trie(word)
    if node.has_children?
      node.flag = false
    elsif !node.has_children?
      node.flag = false
      delete_continued(word, node)
    end
    @count -= 1
  end

  def delete_continued(word, node)
    last_letter = word[-1]
    sub_string = word[0...-1]
    node = traverse_trie(sub_string)

    if node.children.key?(last_letter) && node.flag == false
      node.children.delete(last_letter)
      delete(sub_string)
    elsif node.children.key?([last_letter]) && node.flag == true
      node.children.delete(last_letter)
    end
  end
end

#objects and methods
#core types specifically hashes and nested collections
#Mythical creatures

trie = CompleteMe.new
trie.insert("pize")
trie.insert("pizza")
trie.insert("pizzicato")
trie.insert("pizzle")
binding.pry
trie.delete("pizza")
search = trie.traverse_trie("pizza")
binding.pry



