require 'test_helper'

class WebpackRailsTest < ActionDispatch::IntegrationTest
  test "it shows JS" do
    get_asset 'application.js'

    assert_match "Application Test Success", response.body
  end

  test "it resolves require" do
    get_asset 'require_test.js'

    assert_match "This is /module1", response.body
  end

  test "it resolves relative module" do
    get_asset 'require_relative_test.js'

    assert_match "This is /require_relative/module1", response.body
  end

  test "it resolves npm installed module" do
    get_asset 'require_library_test.js'

    assert_match "http://getbootstrap.com/javascript", response.body
  end

  def get_asset(file)
    get "/assets/#{file}"
  end
end
