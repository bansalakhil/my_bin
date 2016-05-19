require 'test_helper'

class JsBinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @js_bin = js_bins(:one)
  end

  test "should get index" do
    get js_bins_url
    assert_response :success
  end

  test "should get new" do
    get new_js_bin_url
    assert_response :success
  end

  test "should create js_bin" do
    assert_difference('JsBin.count') do
      post js_bins_url, params: { js_bin: { css: @js_bin.css, html: @js_bin.html, js: @js_bin.js } }
    end

    assert_redirected_to js_bin_path(JsBin.last)
  end

  test "should show js_bin" do
    get js_bin_url(@js_bin)
    assert_response :success
  end

  test "should get edit" do
    get edit_js_bin_url(@js_bin)
    assert_response :success
  end

  test "should update js_bin" do
    patch js_bin_url(@js_bin), params: { js_bin: { css: @js_bin.css, html: @js_bin.html, js: @js_bin.js } }
    assert_redirected_to js_bin_path(@js_bin)
  end

  test "should destroy js_bin" do
    assert_difference('JsBin.count', -1) do
      delete js_bin_url(@js_bin)
    end

    assert_redirected_to js_bins_path
  end
end
