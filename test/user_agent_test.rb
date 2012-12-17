require 'test/unit'
require File.expand_path('../../lib/user_agent_helper', __FILE__)

class BrowserTest < Test::Unit::TestCase
  UA = UserAgentHelper::UserAgent

  def test_ie
    @ua = UA.new("Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)")
    assert @ua.ie?
    assert @ua.ie9?
    assert @ua.windows?
    assert_equal "9.0", @ua.version
    assert_equal 9, @ua.version_number
    assert_equal "ie ie9 windows", @ua.html_class
  end

  def test_chrome
    @ua = UA.new("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.47 Safari/536.11")
    assert @ua.chrome?
    assert @ua.osx?
    assert @ua.mac?
    assert ! @ua.safari?
    assert @ua.webkit?
    assert_equal 20, @ua.version_number
    assert_equal "chrome mac osx webkit", @ua.html_class
    assert_equal "20.0.1132.47", @ua.version
  end

  def test_ipod_touch
    @ua = UA.new("Mozilla/5.0 (iPod; U; CPU like Mac OS X; en) AppleWebKit/420.1 (KHTML, like Geckto) Version/3.0 Mobile/3A101a Safari/419.3")
    assert "3.0", @ua.version
    assert_equal "ios ipod webkit", @ua.html_class
  end

  def test_ipad_421
    @ua = UA.new("Mozilla/5.0 (iPad; U; CPU OS 4_2_1 like Mac OS X; ja-jp) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8C148 Safari/6533.18.5")
    assert_equal "4.2.1", @ua.version
    assert_equal "ios ipad webkit", @ua.html_class
  end

  def test_iphone
    @ua = UA.new("Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420 (KHTML, like Gecko) Version/3.0 Mobile/1C28 Safari/419.3")
    assert @ua.ios?
    assert @ua.webkit?
    assert ! @ua.osx?
    assert ! @ua.safari?
    assert_equal "ios iphone webkit", @ua.html_class
  end
end
