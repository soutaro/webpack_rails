require 'test_helper'

class ConfigTest < ActiveSupport::TestCase
  test "Config.merge merges hash" do
    result = WebpackRails::Config.merge({ a: 1, b: 2}, { b: :b, c: :c })
    assert_equal({ a: 1, b: :b, c: :c }, result)
  end

  test "Config.merge merges hash in hash" do
    result = WebpackRails::Config.merge({ a: { x: 1 } }, { a: { y: 2 }})
    assert_equal({ a: { x: 1, y: 2 } }, result)
  end

  test "Config.merge joins array" do
    result = WebpackRails::Config.merge({ a: [1], b: :b, c: [true] }, { a: [2], b: [:c], c: false })
    assert_equal({ a: [1, 2], b: [:b, :c], c: [true, false] }, result)
  end

  test "Config.merge does not merge hash and value" do
    result = WebpackRails::Config.merge({ a: {} }, { a: 3 })
    assert_equal({ a: 3 }, result)
  end
end
