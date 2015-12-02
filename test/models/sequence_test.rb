require 'test_helper'

class SequenceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "get parent topic with one level" do
    t = topics :Topic_2
    s = sequences :Sequence_3
    assert_equal t, s.get_parent_topic
  end

  test "parent topic with one level" do 
    t = topics :Topic_2
    s = sequences :Sequence_3
    assert_equal t, s.parent_topic
  end

  test "get parent topic with two levels" do
    t = topics :Topic_2
    s = sequences :Sequence_04
    assert_equal t, s.get_parent_topic
  end

  test "parent topic with two levels" do 
    t = topics :Topic_2
    s = sequences :Sequence_04
    assert_equal t, s.parent_topic
  end

  #test "get parent topic with three levels" do
  #  t = topics :Topic_2
  #  s = Sequence.find_by_name '3rd Sequence'
  #  assert_equal t, s.get_parent_topic
  #end

  #test "parent topic with three levels" do
  #  t = topics :Topic_2
  #  s = Sequence.find_by_name '3rd Sequence'
  #  assert_equal t, s.parent_topic
  #end

  #test "get parent topic with one lower level" do
  #  t = topics :Topic_15
  #  s = Sequence.find_by_name '3rd Sequence'
  #  s.parent.topic = t
  #  assert_equal t, s.get_parent_topic
  #end

  #test "parent topic with one lower level" do
  #  t = topics :Topic_15
  #  s = Sequence.find_by_name '3rd Sequence'
  #  s.parent.topic = t
  #  assert_equal t, s.parent_topic
  #end

  test "get parent topic with no parent" do
    s = sequences :Sequence_1
    assert_equal nil, s.get_parent_topic
  end

  test "parent topic with no parent" do
    s = sequences :Sequence_1
    assert_equal nil, s.parent_topic
  end
end
