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
    assert @complete_me.root_node.children["p"].has_key?("i")
    assert @complete_me.root_node.children["p"].children["i"].has_key?("z")
    assert @complete_me.root_node.children["p"].children["i"].children["z"].has_key?("z")
    assert @complete_me.root_node.children["p"].children["i"].children["z"].children["z"].has_key?("a")
  end

  def test_populate_creates_flag_with_one_word
    word_set = "pizza\n"
    @complete_me.populate(word_set)
    assert @complete_me.root_node.children["p"].children["i"].children["z"].children["z"].flag
  end

  def test_populate_inserts_two_newline_separated_words
    word_set = "pizza\npie"
    @complete_me.populate(word_set)
    assert_equal ["p"], @complete_me.root_node.children.keys
    assert_equal ["i"], @complete_me.root_node.children["p"].keys
    assert_equal ["z", "e"], @complete_me.root_node.children["p"].children["i"].keys
    assert_equal ["z"], @complete_me.root_node.children["p"].children["i"].children["z"].keys
    assert_equal ["a"], @complete_me.root_node.children["p"].children["i"].children["z"].children["z"].keys
    assert_equal [], @complete_me.root_node.children["p"].children["i"].children["e"].keys
  end

  def test_populate_flags_words_when_inserting_two_words
    word_set = "pizza\npie"
    @complete_me.populate(word_set)
    assert @complete_me.root_node.children["p"].children["i"].flag
    assert @complete_me.root_node.children["p"].children["i"].children["z"].children["z"].flag
  end

  def test_populate_inserts_words_from_file
    dictionary = File.read('../data/test_dictionary.txt')
    @complete_me.populate(dictionary)
    # Root
    assert_equal [a..z], @complete_me.root_node.children.keys
    # First two
    assert_equal ["p"], @complete_me.root_node.children["a"].keys
    assert_equal ["p"], @complete_me.root_node.children["a"].children["p"].keys
    assert_equal ["l"], @complete_me.root_node.children["a"].children["p"].children["p"].keys
    assert_equal ["e"], @complete_me.root_node.children["a"].children["p"].children["p"].children["l"].keys
    assert_equal [], @complete_me.root_node.children["a"].children["p"].children["p"].children["l"].children["e"].keys

    assert_equal ["a"], @complete_me.root_node.children["b"].keys
    assert_equal ["n"], @complete_me.root_node.children["b"].children["a"].keys
    assert_equal ["a"], @complete_me.root_node.children["b"].children["a"].children["n"].keys
    assert_equal ["n"], @complete_me.root_node.children["b"].children["a"].children["n"].children["a"].keys
    assert_equal ["a"], @complete_me.root_node.children["b"].children["a"].children["n"].children["a"].children["n"].keys
    assert_equal [], @complete_me.root_node.children["b"].children["a"].children["n"].children["a"].children["n"].children["a"].keys
    
    # Middle two (by letters of alphabet)
    assert_equal ["o"], @complete_me.root_node.children["m"].keys
    assert_equal ["o"], @complete_me.root_node.children["m"].children["o"].keys
    assert_equal ["n"], @complete_me.root_node.children["m"].children["o"].children["o"].keys
    assert_equal [], @complete_me.root_node.children["m"].children["o"].children["o"].children["n"].keys

    assert_equal ["e"], @complete_me.root_node.children["n"].keys
    assert_equal ["s"], @complete_me.root_node.children["n"].children["e"].keys
    assert_equal ["t"], @complete_me.root_node.children["n"].children["e"].children["s"].keys
    assert_equal [], @complete_me.root_node.children["n"].children["e"].children["s"].children["t"].keys

    #Last two
    assert_equal ["y"], @complete_me.root_node.children["x"].keys
    assert_equal ["l"], @complete_me.root_node.children["x"].children["y"].keys
    assert_equal ["o"], @complete_me.root_node.children["x"].children["y"].children["l"].keys
    assert_equal ["p"], @complete_me.root_node.children["x"].children["y"].children["l"].children["o"].keys
    assert_equal ["h"], @complete_me.root_node.children["x"].children["y"].children["l"].children["o"].children["p"].keys
    assert_equal ["o"], @complete_me.root_node.children["x"].children["y"].children["l"].children["o"].children["p"].children["h"].keys
    assert_equal ["n"], @complete_me.root_node.children["x"].children["y"].children["l"].children["o"].children["p"].children["h"].children["o"].keys
    assert_equal ["e"], @complete_me.root_node.children["x"].children["y"].children["l"].children["o"].children["p"].children["h"].children["o"].children["n"].keys
    assert_equal [], @complete_me.root_node.children["x"].children["y"].children["l"].children["o"].children["p"].children["h"].children["o"].children["n"].children["e"].keys

    assert_equal ["e"], @complete_me.root_node.children["z"].keys
    assert_equal ["r"], @complete_me.root_node.children["z"].children["e"].keys
    assert_equal ["o"], @complete_me.root_node.children["z"].children["e"].children["r"].keys
    assert_equal [], @complete_me.root_node.children["z"].children["e"].children["r"].children["o"].keys
  end

  def test_words_with_same_starting_letter_from_file_are_populated
    assert_equal ["i"], @complete_me.root_node.children["p"].keys
    assert_equal ["z", "e"], @complete_me.root_node.children["p"].children["i"].keys
    assert_equal ["z"], @complete_me.root_node.children["p"].children["i"].children["z"].keys
    assert_equal ["a"], @complete_me.root_node.children["p"].children["i"].children["z"].children["z"].keys
    assert_equal [], @complete_me.root_node.children["p"].children["i"].children["z"].children["z"].children["a"].keys
    assert_equal [], @complete_me.roor_node.children["p"].children["i"].children["e"].keys
  end

end
