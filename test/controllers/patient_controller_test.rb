require 'test_helper'

class PatientControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get patient_index_url
    assert_response :success
  end

  test "should get show" do
    get patient_show_url
    assert_response :success
  end

  test "should get create" do
    get patient_create_url
    assert_response :success
  end

  test "should get update" do
    get patient_update_url
    assert_response :success
  end

  test "should get destroy" do
    get patient_destroy_url
    assert_response :success
  end

end
