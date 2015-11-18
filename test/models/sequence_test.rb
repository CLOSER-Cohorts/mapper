require 'test_helper'

class SequenceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "get parent topic with one level" do
    t = Topic.find_by_name 'North'
    s = Sequence.find_by_name '2:1 Sequence'
    assert_equal t, s.get_parent_topic
  end

  test "parent topic with one level" do 
    t = Topic.find_by_name 'North'
    s = Sequence.find_by_name '2:1 Sequence'
    assert_equal t, s.parent_topic
  end

  test "get parent topic with two levels" do
    t = Topic.find_by_name 'North'
    s = Sequence.find_by_name '2:2 Sequence'
    assert_equal t, s.get_parent_topic
  end

  test "parent topic with two levels" do 
    t = Topic.find_by_name 'North'
    s = Sequence.find_by_name '2:2 Sequence'
    assert_equal t, s.parent_topic
  end

  test "get parent topic with three levels" do
    t = Topic.find_by_name 'North'
    s = Sequence.find_by_name '3rd Sequence'
    assert_equal t, s.get_parent_topic
  end

  test "parent topic with three levels" do
    t = Topic.find_by_name 'North'
    s = Sequence.find_by_name '3rd Sequence'
    assert_equal t, s.parent_topic
  end

  test "get parent topic with one lower level" do
    t = Topic.find_by_name 'East'
    s = Sequence.find_by_name '3rd Sequence'
    s.parent.topic = t
    assert_equal t, s.get_parent_topic
  end

  test "parent topic with one lower level" do
    t = Topic.find_by_name 'East'
    s = Sequence.find_by_name '3rd Sequence'
    s.parent.topic = t
    assert_equal t, s.parent_topic
  end

  test "get parent topic with no parent" do
    s = Sequence.find_by_name '1st Sequence'
    assert_equal nil, s.get_parent_topic
  end

  test "parent topic with no parent" do
    s = Sequence.find_by_name '1st Sequence'
    assert_equal nil, s.parent_topic
  end
end
