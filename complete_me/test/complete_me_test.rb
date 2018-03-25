require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/complete_me'

class CompleteMeTest < MiniTest::Test

  def setup
    @complete_me = CompleteMe.new
  end

  def test_it_exists
    assert_instance_of CompleteMe, @complete_me
  end


  def test_it_can_count
    @complete_me.insert("hello")
    @complete_me.insert("test")
    actual = @complete_me.count
    expected = 2

    assert_equal expected, actual
  end

  def test_suggest_takes_substring
    @complete_me.insert("pizza")
    actual = @complete_me.suggest("piz")
    expected = "pizza"

    assert_equal expected, actual
  end

  def test_it_doesnt_suggest_completed_words
    @complete_me.insert("stat")
    @complete_me.insert("status")


    actual =
    expected =

    assert_equal expected, actual
  end

  def test_suggest_uses_weight


  end

end
