require 'test_helper'

class VariablesControllerTest < ActionController::TestCase
  setup do
    @variable = variables :Variable_1
    @instrument = @variable.instrument
  end

  test "should get index" do
    get :index, {'instrument_id' => @instrument.id}
    assert_response :success
    assert_not_nil assigns(:variables)
  end

  test "should get new" do
    get :new, {'instrument_id' => @instrument.id}
    assert_response :success
  end

  test "should create variable" do
    assert_difference('Variable.count') do
      post :create, {instrument_id: @instrument.id, variable: { instrument_id: @instrument.id, var_type: 'Normal', name: 'testing', label: @variable.label }}
    end

    assert_redirected_to variable_path(assigns(:variable))
  end

  test "should show variable" do
    get :show, id: @variable
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @variable
    assert_response :success
  end

  test "should update variable" do
    patch :update, id: @variable, variable: {  }
    assert_redirected_to variable_path(assigns(:variable))
  end

  test "should destroy variable" do
    assert_difference('Variable.count', -1) do
      delete :destroy, id: @variable
    end

    assert_redirected_to instrument_path assigns(:instrument)
  end
end
