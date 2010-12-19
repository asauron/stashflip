require 'test_helper'

class FavoriteMapsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:favorite_maps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create favorite_map" do
    assert_difference('FavoriteMap.count') do
      post :create, :favorite_map => { }
    end

    assert_redirected_to favorite_map_path(assigns(:favorite_map))
  end

  test "should show favorite_map" do
    get :show, :id => favorite_maps(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => favorite_maps(:one).to_param
    assert_response :success
  end

  test "should update favorite_map" do
    put :update, :id => favorite_maps(:one).to_param, :favorite_map => { }
    assert_redirected_to favorite_map_path(assigns(:favorite_map))
  end

  test "should destroy favorite_map" do
    assert_difference('FavoriteMap.count', -1) do
      delete :destroy, :id => favorite_maps(:one).to_param
    end

    assert_redirected_to favorite_maps_path
  end
end
