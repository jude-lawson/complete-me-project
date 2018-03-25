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
end
