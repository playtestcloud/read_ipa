require 'test_helper'
require 'read_ipa'

class InfoPlistTest < Minitest::Test
  def setup
    str = File.read(File.dirname(__FILE__) + '/Info.plist')
    @info_plist = ReadIpa::InfoPlist.new(str)
    ipad_only_str = File.read(File.dirname(__FILE__) + '/IpadOnlyInfo.plist')
    @ipad_only_info_plist = ReadIpa::InfoPlist.new(ipad_only_str)
    iphone_only_str = File.read(File.dirname(__FILE__) + '/IphoneOnlyInfo.plist')
    @iphone_only_info_plist = ReadIpa::InfoPlist.new(iphone_only_str)
  end

  def test_version
    assert_equal(@info_plist.version, "1.2.2.4")
  end

  def test_short_version
    # asserting nil because the test file doesn't have this key
    assert_nil(@info_plist.short_version)
  end

  def test_name
    assert_equal(@info_plist.name, "MultiG")
  end

  def test_target_os_version
    assert_equal(@info_plist.target_os_version, "4.1")
  end

  def test_minimum_os_version
    assert_equal(@info_plist.minimum_os_version, "3.1")
  end

  def test_url_schemes
    assert_equal(@info_plist.url_schemes, [])
  end

  def test_bundle_identifier
    assert_equal("com.dcrails.multig", @info_plist.bundle_identifier)
  end

  def test_icon_prerendered
    assert_equal(false, @info_plist.icon_prerendered)
  end

  def test_executable_file_name
    assert_equal("MultiG", @info_plist.executable_file_name)
  end

  def test_for_iphone
    assert_equal(true, @info_plist.for_iphone?)
  end

  def test_not_for_iphone
    assert_equal(false, @ipad_only_info_plist.for_iphone?)
  end

  def test_for_ipad
    assert_equal(true, @info_plist.for_ipad?)
  end

  def test_not_for_ipad
    assert_equal(false, @iphone_only_info_plist.for_ipad?)
  end
end