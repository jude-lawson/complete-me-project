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

end
