require 'test_helper'

class ComposersControllerTest < ActionController::TestCase
  setup do
    @composer = composers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:composers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create composer" do
    assert_difference('Composer.count') do
      post :create, composer: @composer.attributes
    end

    assert_redirected_to composer_path(assigns(:composer))
  end

  test "should show composer" do
    get :show, id: @composer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @composer
    assert_response :success
  end

  test "should update composer" do
    put :update, id: @composer, composer: @composer.attributes
    assert_redirected_to composer_path(assigns(:composer))
  end

  test "should destroy composer" do
    assert_difference('Composer.count', -1) do
      delete :destroy, id: @composer
    end

    assert_redirected_to composers_path
  end
end
