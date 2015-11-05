require 'test_helper'

class AddCloserCentresTest < ActiveSupport::TestCase

  test "mcs is cls" do
    user = User.new
    user.study = 'MCS'
    assert_equal true, user.cls?
  end

  test "hcs is cls" do
    user = User.new
    user.study = 'HCS'
    assert_equal false, user.cls?
  end

  test "mcs is soton" do
    user = User.new
    user.study = 'MCS'
    assert_equal false, user.soton?
  end

  test "hcs is soton" do
    user = User.new
    user.study = 'HCS'
    assert_equal true, user.soton?
  end
end
