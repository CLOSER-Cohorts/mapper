require 'test_helper'

class InstrumentsControllerTest < ActionController::TestCase
  setup do
    @instrument = instruments :Instrument_1
  end

  test "should get index" do
    sign_in users :User_1
    get :index
    assert_response :success
    assert_not_nil assigns(:instruments)
  end

  test "should get new" do
    sign_in users :User_1
    get :new
    assert_response :success
  end

  test "should create instrument" do
    sign_in users :User_1
    assert_difference('Instrument.count') do
      post :create, instrument: { port: @instrument.port, prefix: @instrument.prefix }
    end

    assert_redirected_to instrument_path(assigns(:instrument))
  end

  test "should show instrument" do
    sign_in users :User_1
    get :show, id: @instrument
    assert_response :success
  end

  test "should get edit" do
    sign_in users :User_1
    get :edit, id: @instrument
    assert_response :success
  end

  test "should update instrument" do
    sign_in users :User_1
    patch :update, id: @instrument, instrument: { port: @instrument.port, prefix: @instrument.prefix }
    assert_redirected_to instrument_path(assigns(:instrument))
  end

  test "should destroy instrument" do
    sign_in users :User_1
    assert_difference('Instrument.count', -1) do
      delete :destroy, id: @instrument
    end

    assert_redirected_to instruments_path
  end
end
