require 'test_helper'

class InstallsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @install = installs(:one)
  end

  test "should get index" do
    get installs_url
    assert_response :success
  end

  test "should get new" do
    get new_install_url
    assert_response :success
  end

  test "should create install" do
    assert_difference('Install.count') do
      post installs_url, params: { install: { index: @install.index } }
    end

    assert_redirected_to install_url(Install.last)
  end

  test "should show install" do
    get install_url(@install)
    assert_response :success
  end

  test "should get edit" do
    get edit_install_url(@install)
    assert_response :success
  end

  test "should update install" do
    patch install_url(@install), params: { install: { index: @install.index } }
    assert_redirected_to install_url(@install)
  end

  test "should destroy install" do
    assert_difference('Install.count', -1) do
      delete install_url(@install)
    end

    assert_redirected_to installs_url
  end
end
