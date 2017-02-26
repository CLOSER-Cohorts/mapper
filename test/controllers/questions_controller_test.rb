require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
  setup do
    @question = questions :Question_1
    @instrument = @question.instrument
  end

  test "should get index" do
    get :index, {'instrument_id' => @instrument.id}
    assert_response :success
    assert_not_nil assigns(:questions)
  end

  test "should get new" do
    get :new, {'instrument_id' => @instrument.id}
    assert_response :success
  end

  test "should create question" do
    assert_difference('Question.count') do
      post :create, {instrument_id: @instrument.id, question: { 'instrument_id' => @instrument.id }}
    end

    assert_equal 'http://test.host' + instrument_path(@question.instrument), @response.redirect_url.split('?')[0]
  end

  test "should show question" do
    get :show, id: @question
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @question
    assert_response :success
  end

  test "should update question" do
    patch :update, id: @question, question: { 'instrument_id' => @instrument.id }
    assert_equal instrument_questions_url(@question.instrument), @response.redirect_url.split('?')[0]
  end

  test "should destroy question" do
    assert_difference('Question.count', -1) do
      delete :destroy, id: @question
    end

    assert_redirected_to instrument_path(assigns(:instrument))
  end
end
