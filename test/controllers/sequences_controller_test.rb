require 'test_helper'

class SequencesControllerTest < ActionController::TestCase
  setup do
    @sequence = sequences :Sequence_1
    @instrument = @sequence.instrument
  end

  test "should get index" do
    get :index, {'instrument_id' => @instrument.id}
    assert_response :success
    assert_not_nil assigns(:sequences)
  end

  test "should get new" do
    get :new, {'instrument_id' => @instrument.id}
    assert_response :success
  end

  test "should create sequence" do
    assert_difference('Sequence.count') do
      post :create, {instrument_id: @sequence.instrument_id, sequence: { instrument_id: @sequence.instrument_id, name: 'test name', parent_id: @sequence.parent_id }}
    end

    assert_response :redirect
    assert_equal instrument_url(@sequence.instrument), @response.redirect_url.split('?')[0]
  end

  test "should show sequence" do
    get :show, id: @sequence
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sequence
    assert_response :success
  end

  test "should update sequence" do
    patch :update, id: @sequence, sequence: { instrument_id: @sequence.instrument_id, name: @sequence.name, parent_id: @sequence.parent_id }
    assert_response :redirect
    assert_equal instrument_url(@sequence.instrument), @response.redirect_url.split('?')[0]
  end

  test "should destroy sequence" do
    assert_difference('Sequence.count', -1) do
      delete :destroy, id: @sequence
    end

    assert_redirected_to sequences_path
  end
end
