require "test_helper"

class Api::V1::JuegosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_juegos_index_url
    assert_response :success
  end
end
