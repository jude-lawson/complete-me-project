require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/complete_me'

# Test for main CompleteMe class
class CompleteMeTest < MiniTest::Test

  def setup
    @complete_me = CompleteMe.new
  end

  def test_it_exists
    assert_instance_of CompleteMe, @complete_me
  end

end
