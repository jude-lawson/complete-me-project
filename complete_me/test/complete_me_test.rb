require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/complete_me'

# Tests for main CompleteMe class
class CompleteMeTest < MiniTest::Test

  def setup
    @complete_me = CompleteMe.new
  end

  def test_it_exists
    assert_instance_of CompleteMe, @complete_me
  end

  # def test_it_can_count
  #   @complete_me.insert("hello")
  #   @complete_me.insert("test")
  #   actual = @complete_me.count
  #   expected = 2

  #   assert_equal expected, actual
  # end

  def test_suggest_takes_substring
    @complete_me.insert("pizza")
    actual = @complete_me.suggest("piz")
    expected = "pizza"

    assert_equal expected, actual
  end

  def test_it_doesnt_suggest_completed_words
    @complete_me.insert("stat")
    @complete_me.insert("status")

    actual = @complete_me.suggest("stat")
    expected = ["status"]

    assert_equal expected, actual
  end

  def test_suggest_uses_weight
    @complete_me.insert("pize")
    @complete_me.insert("pizza")
    @complete_me.insert("pizzicato")
    @complete_me.insert("pizzle")
    @complete_me.select("piz", "pizzeria")

    actual = complete_me.suggest("piz")
    expected = ["pizzeria", "pize", "pizza", "pizzicato", "pizzle"]

    assert_equal expected, actual
  end

  def test_node_can_be_inserted
    @complete_me.insert("hello")
    assert_instance_of Node, @complete_me.root_node
  end

  def test_child_node_has_correct_children_types
    @complete_me.insert("hi")
    assert_instance_of Node, @complete_me.root_node.children["h"]
    assert_instance_of Node, @complete_me.root_node.children["h"].children["i"]
  end

  def test_root_node_has_correct_child
    @complete_me.insert("hi")
    assert_equal ["h"], @complete_me.root_node.children.keys
  end

  def test_root_node_child_has_correct_state
    @complete_me.insert("cat")
    assert_equal ({}), @complete_me.root_node.children["c"].weight
    assert_equal false, @complete_me.root_node.children["c"].flag
    assert_equal ["a"], @complete_me.root_node.children["c"].children.keys
  end

  def test_that_root_node_child_has_correct_child
    @complete_me.insert("dog")
    root_child = @complete_me.root_node.children["d"]
    assert_instance_of Node, root_child.children["o"]
    # binding.pry
    assert_equal ["o"], root_child.children.keys
    assert_equal ({}), root_child.children["o"].weight
    assert_equal false, root_child.children["o"].flag
    assert_instance_of Node, root_child.children["o"].children["g"]
  end

  def test_word_flag_is_correct_after_inserting_word
    @complete_me.insert("hi")
    expected = true
    # Later this needs to be updated with traversal method, rather than directly accessing it
    actual = @complete_me.root_node.children["h"].children["i"].flag
    assert_equal expected, actual
  end

  def test_that_populate_can_enter_one_word_with_trailing_newline
    word_set = "pizza\n"
    @complete_me.populate(word_set)
    assert_equal ["p"], @complete_me.root_node.children.keys
    assert @complete_me.root_node.children["p"].children.has_key?("i")
    assert @complete_me.root_node.children["p"].children["i"].children.has_key?("z")
    assert @complete_me.root_node.children["p"].children["i"].children["z"].children.has_key?("z")
    assert @complete_me.root_node.children["p"].children["i"].children["z"].children["z"].children.has_key?("a")
  end

  def test_populate_creates_flag_with_one_word
    word_set = "pizza\n"
    @complete_me.populate(word_set)
    assert @complete_me.root_node.children["p"].children["i"].children["z"].children["z"].children["a"].flag
  end

  def test_populate_inserts_two_newline_separated_words
    word_set = "pizza\npie"
    @complete_me.populate(word_set)
    assert_equal ["p"], @complete_me.root_node.children.keys
    assert_equal ["i"], @complete_me.root_node.children["p"].children.keys
    assert_equal ["z", "e"], @complete_me.root_node.children["p"].children["i"].children.keys
    assert_equal ["z"], @complete_me.root_node.children["p"].children["i"].children["z"].children.keys
    assert_equal ["a"], @complete_me.root_node.children["p"].children["i"].children["z"].children["z"].children.keys
    assert_equal [], @complete_me.root_node.children["p"].children["i"].children["e"].children.keys
  end

  def test_populate_flags_words_when_inserting_two_words
    word_set = "pizza\npie"
    @complete_me.populate(word_set)
    assert @complete_me.root_node.children["p"].children["i"].children["e"].flag
    assert @complete_me.root_node.children["p"].children["i"].children["z"].children["z"].children["a"].flag
  end

  def test_populate_inserts_words_from_file
    dictionary = File.read("./data/test_dictionary.txt")
    @complete_me.populate(dictionary)
    # Root
    # File has two words out of alphabetical order and no word starting with 'y'
    assert_equal %w(a b d c e f g h i j k l m n o p q r s t u v w x z), @complete_me.root_node.children.keys
    # First two
    assert_equal ["p"], @complete_me.root_node.children["a"].children.keys
    assert_equal ["p"], @complete_me.root_node.children["a"].children["p"].children.keys
    assert_equal ["l"], @complete_me.root_node.children["a"].children["p"].children["p"].children.keys
    assert_equal ["e"], @complete_me.root_node.children["a"].children["p"].children["p"].children["l"].children.keys
    assert_equal [], @complete_me.root_node.children["a"].children["p"].children["p"].children["l"].children["e"].children.keys

    assert_equal ["a"], @complete_me.root_node.children["b"].children.keys
    assert_equal ["n"], @complete_me.root_node.children["b"].children["a"].children.keys
    assert_equal ["a"], @complete_me.root_node.children["b"].children["a"].children["n"].children.keys
    assert_equal ["n"], @complete_me.root_node.children["b"].children["a"].children["n"].children["a"].children.keys
    assert_equal ["a"], @complete_me.root_node.children["b"].children["a"].children["n"].children["a"].children["n"].children.keys
    assert_equal [], @complete_me.root_node.children["b"].children["a"].children["n"].children["a"].children["n"].children["a"].children.keys
    
    # Middle two (by letters of alphabet)
    assert_equal ["o"], @complete_me.root_node.children["m"].children.keys
    assert_equal ["o"], @complete_me.root_node.children["m"].children["o"].children.keys
    assert_equal ["n"], @complete_me.root_node.children["m"].children["o"].children["o"].children.keys
    assert_equal [], @complete_me.root_node.children["m"].children["o"].children["o"].children["n"].children.keys

    assert_equal ["e"], @complete_me.root_node.children["n"].children.keys
    assert_equal ["s"], @complete_me.root_node.children["n"].children["e"].children.keys
    assert_equal ["t"], @complete_me.root_node.children["n"].children["e"].children["s"].children.keys
    assert_equal [], @complete_me.root_node.children["n"].children["e"].children["s"].children["t"].children.keys

    #Last two
    assert_equal ["y"], @complete_me.root_node.children["x"].children.keys
    assert_equal ["l"], @complete_me.root_node.children["x"].children["y"].children.keys
    assert_equal ["o"], @complete_me.root_node.children["x"].children["y"].children["l"].children.keys
    assert_equal ["p"], @complete_me.root_node.children["x"].children["y"].children["l"].children["o"].children.keys
    assert_equal ["h"], @complete_me.root_node.children["x"].children["y"].children["l"].children["o"].children["p"].children.keys
    assert_equal ["o"], @complete_me.root_node.children["x"].children["y"].children["l"].children["o"].children["p"].children["h"].children.keys
    assert_equal ["n"], @complete_me.root_node.children["x"].children["y"].children["l"].children["o"].children["p"].children["h"].children["o"].children.keys
    assert_equal ["e"], @complete_me.root_node.children["x"].children["y"].children["l"].children["o"].children["p"].children["h"].children["o"].children["n"].children.keys
    assert_equal [], @complete_me.root_node.children["x"].children["y"].children["l"].children["o"].children["p"].children["h"].children["o"].children["n"].children["e"].children.keys

    assert_equal ["e"], @complete_me.root_node.children["z"].children.keys
    assert_equal ["r"], @complete_me.root_node.children["z"].children["e"].children.keys
    assert_equal ["o"], @complete_me.root_node.children["z"].children["e"].children["r"].children.keys
    assert_equal [], @complete_me.root_node.children["z"].children["e"].children["r"].children["o"].children.keys
  end

  def test_words_with_same_starting_letter_from_file_are_populated
    dictionary = File.read("./data/test_dictionary.txt")
    @complete_me.populate(dictionary)
    assert_equal ["i"], @complete_me.root_node.children["p"].children.keys
    assert_equal ["z", "e"], @complete_me.root_node.children["p"].children["i"].children.keys
    assert_equal ["z"], @complete_me.root_node.children["p"].children["i"].children["z"].children.keys
    assert_equal ["a"], @complete_me.root_node.children["p"].children["i"].children["z"].children["z"].children.keys
    assert_equal [], @complete_me.root_node.children["p"].children["i"].children["z"].children["z"].children["a"].children.keys
    assert_equal [], @complete_me.root_node.children["p"].children["i"].children["e"].children.keys
  end

  def test_select_raises_priority
    skip
    @complete_me.populate("pizza\npie")
    @complete_me.select("pi", "pizza")
    assert_equal ["pizza", "pie"], @complete_me.suggest("piz")
  end

  def test_select_retains_usage_values
    @complete_me.populate("pizza\npie")
    @complete_me.select("pi", "pizza")
    # binding.pry
    assert_equal 1, @complete_me.usage_data["pi"]["pizza"]
    @complete_me.select("pi", "pizza")
    assert_equal 2, @complete_me.usage_data["pi"]["pizza"]
  end

  def test_traverse_walks_trie_with_one_word_branch
    @complete_me.insert("pizza")
    assert_equal ["pizza"], @complete_me.suggest("piz")
  end

  def test_traverse_walks_trie_with_two_word_branch
    @complete_me.populate("pizza\npie")
    assert_equal ["pizza", "pie"], @complete_me.suggest("pi")
  end

  def test_general_result_of_trie_traversal
    dictionary = File.read('./data/test_dictionary.txt')
    @complete_me.populate(dictionary)
    assert_equal ["constellation"], @complete_me.suggest("const")
    assert_equal ["pizza", "pie"], @complete_me.suggest("pi")
    assert_equal ["xylophone"], @complete_me.suggest("xylop")
    assert_equal ["apple"], @complete_me.suggest("apple")
  end

end
