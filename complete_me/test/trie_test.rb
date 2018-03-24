require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/trie'

class TrieTest < MiniTest::Test
  def setup
    @trie = Trie.new
  end

  def test_it_exists
    assert_instance_of Trie, @trie
  end
end
