require "test_helper"

class CastlesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get castles_index_url
    assert_response :success
  end

  test "should get show" do
    get castles_show_url
    assert_response :success
  end
end
