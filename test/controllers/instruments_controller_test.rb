require 'test_helper'

class InstrumentsControllerTest < ActionController::TestCase
  setup do
    @instrument = instruments(:ione)
    @user = users :User_1
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:instruments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create instrument" do
    assert_difference('Instrument.count') do
      post :create, instrument: { port: @instrument.port, prefix: @instrument.prefix }
    end

    assert_redirected_to instrument_path(assigns(:instrument))
  end

  test "should show instrument" do
    get :show, id: @instrument
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @instrument
    assert_response :success
  end

  test "should update instrument" do
    patch :update, id: @instrument, instrument: { port: @instrument.port, prefix: @instrument.prefix }
    assert_redirected_to instrument_path(assigns(:instrument))
  end

  test "should destroy instrument" do
    assert_difference('Instrument.count', -1) do
      delete :destroy, id: @instrument
    end

    assert_redirected_to instruments_path
  end
end
