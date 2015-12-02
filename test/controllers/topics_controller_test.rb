require 'test_helper'

class TopicsControllerTest < ActionController::TestCase
  setup do
    @topic = topics :Topic_1
  end

  test "should get index" do
    sign_in users :User_1
    get :index
    assert_response :success
    assert_not_nil assigns(:topics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create topic" do
    assert_difference('Topic.count') do
      post :create, topic: { name: @topic.name, parent_id: @topic.parent_id }
    end

    assert_redirected_to topic_path(assigns(:topic))
  end

  test "should show topic" do
    get :show, id: @topic
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @topic
    assert_response :success
  end

  test "should update topic" do
    patch :update, id: @topic, topic: { name: @topic.name, parent_id: @topic.parent_id }
    assert_redirected_to topic_path(assigns(:topic))
  end

  test "should destroy topic" do
    topic = Topic.all.last
    assert_difference('Topic.count', -1) do
      delete :destroy, id: topic
    end

    assert_redirected_to topics_path
  end

  test "should not destroy topic" do
    assert_difference('Topic.count', 0) do
      assert_raises ActiveRecord::InvalidForeignKey do
        delete :destroy, id: @topic
      end
    end

    assert_response :success
  end
end
