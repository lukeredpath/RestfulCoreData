require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project" do
    assert_difference('Project.count') do
      post :create, :project => projects(:one).attributes
    end

    assert_redirected_to project_path(assigns(:project))
  end

  test "should show project" do
    get :show, :id => projects(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => projects(:one).to_param
    assert_response :success
  end

  test "should update project" do
    put :update, :id => projects(:one).to_param, :project => projects(:one).attributes
    assert_redirected_to project_path(assigns(:project))
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete :destroy, :id => projects(:one).to_param
    end

    assert_redirected_to projects_path
  end
end
