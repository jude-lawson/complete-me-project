require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/node'

class NodeTest < MiniTest::Test

  def setup
    @node = Node.new
  end

  def test_it_exists
    assert_instance_of Node, @node
  end

  def test_node_can_contain_one_child_node
    @node.children["a"] = Node.new
    assert_instance_of Node, @node.children["a"]
  end

  def test_node_can_have_nultiple_child_nodes
    @node.children["a"] = Node.new
    @node.children["j"] = Node.new
    @node.children["l"] = Node.new
    @node.children["z"] = Node.new
    assert_instance_of Node, @node.children["a"]
    assert_instance_of Node, @node.children["j"]
    assert_instance_of Node, @node.children["l"]
    assert_instance_of Node, @node.children["z"]
  end

  def test_node_can_have_no_children
    assert_equal ({}), @node.children
  end

  def test_node_can_be_flagged
    @node.children["b"] = Node.new
    @node.children["b"].children["e"] = Node.new
    @node.children["b"].children["e"].flag = true
    assert @node.children["b"].children["e"].flag
  end

  def test_node_can_be_unflagged
    refute @node.flag
  end

  def test_checking_for_node_child
    @node.children["b"] = Node.new
    assert @node.has_children?
  end

  def test_checking_for_node_without_child_nodes
    refute @node.has_children?
  end


end
