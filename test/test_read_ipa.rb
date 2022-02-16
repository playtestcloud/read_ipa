require 'test_helper'
require 'digest'
require 'read_ipa'

class ReadIpaTest < Minitest::Test
  def setup
    @ipa_file = ReadIpa::IpaFile.new(File.dirname(__FILE__) + '/MultiG.ipa')
  end

  def test_parse
    assert(@ipa_file.plist.keys.count > 0)
  end

  def test_version
    assert_equal(@ipa_file.version, "1.2.2.4")
  end

  def test_short_version
    # asserting nil because the test file doesn't have this key
    assert_nil(@ipa_file.short_version)
  end

  def test_name
    assert_equal(@ipa_file.name, "MultiG")
  end

  def test_target_os_version
    assert_equal(@ipa_file.target_os_version, "4.1")
  end

  def test_minimum_os_version
    assert_equal(@ipa_file.minimum_os_version, "3.1")
  end

  def test_url_schemes
    assert_equal(@ipa_file.url_schemes, [])
  end

  def test_bundle_identifier
    assert_equal("com.dcrails.multig", @ipa_file.bundle_identifier)
  end

  def test_icon_prerendered
    assert_equal(false, @ipa_file.icon_prerendered)
  end

  def test_icon
    assert_equal("3e4ed7f5a30280009fac972f8d4c90d2a91f46b94e7d687a20b8bfedad5ab62a",
                 Digest::SHA256::hexdigest(@ipa_file.icon_file))
  end

  def test_executable_file_name
    assert_equal("MultiG", @ipa_file.executable_file_name)
  end

  def test_executable_file
    assert_equal("227e5272684846d7c8193dbe0995a2df62314d11a069608831f5d38d51ee9c7a",
                 Digest::SHA256::hexdigest(@ipa_file.executable_file))
  end

  def test_for_iphone
    assert_equal(true, @ipa_file.for_iphone?)
  end

  def test_for_ipad
    assert_equal(true, @ipa_file.for_ipad?)
  end
end