require 'test_helper'

class AreaControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get area_index_url
    assert_response :success
  end

  test "should get show" do
    get area_show_url
    assert_response :success
  end

  test "should get create" do
    get area_create_url
    assert_response :success
  end

  test "should get update" do
    get area_update_url
    assert_response :success
  end

  test "should get destroy" do
    get area_destroy_url
    assert_response :success
  end

end
