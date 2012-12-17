# Usage example:
#
#   -# haml
#   %body{class: browser.body_class}
#
#   - if browser.ios?
#     %p Download our mobile app!
#
# Output:
#
#   <body class='webkit safari mac'>
#   <body class='windows ie ie6'>
#
# Resources:
#
# - http://user-agent-string.info/list-of-ua

module UserAgentHelper
  def browser
    UserAgent.new(request.env['HTTP_USER_AGENT'])
  end

  class UserAgent
    UA_REGEXP = %r{([^ /]+)/([^ ]+)(?: \(([^)]+)\))?}

    def initialize(ua)
      @ua_string = ua
      # Splits:
      #   'Mozilla/5.0 (MSIE; x; y) Safari/2.0'
      # into: [
      #   { product:"Mozilla", version:"5.0", details: ['MSIE','x','y']},
      #   { product:"Safari", version:"2.0", details: []}
      # ]
      @ua = ua.scan(UA_REGEXP).map { |r|
        r[2] = r[2].split(';').map { |s| s.strip }  unless r[2].nil?
        { :product => r[0], :version => r[1], :details => r[2] }
      }
    end

    # Browsers
    def webkit?()    product?('AppleWebKit'); end
    def chrome?()    product?('Chrome'); end
    def ios?()       product?('Safari') && product?('Mobile'); end # Mobile Safari
    def safari?()    product?('Safari') && !chrome? && !ios?; end # Desktop Safari
    def gecko?()     product?('Gecko'); end
    def opera?()     product?('Opera'); end
    def ie?()        detail?(/^MSIE/, 'Mozilla'); end

    # OS's and devices
    def linux?()      detail?(/^Linux/, 'Mozilla'); end
    def iphone?()     detail?(/^iPhone/, 'Mozilla'); end
    def ipod?()       detail?(/^iPod/, 'Mozilla'); end
    def android?()    detail?(/^Android/, 'Mozilla'); end
    def nokia?()      detail?(/^Nokia/, 'Mozilla') || detail?(/^Series[38]0/, 'Mozilla'); end
    def ipad?()       detail?(/^iPad/, 'Mozilla'); end
    def windows?()    detail?(/^Windows/, 'Mozilla'); end
    def osx?()        detail?(/^(Intel )?Mac OS X/, 'Mozilla'); end
    def mac?()        detail?(/^Macintosh/, 'Mozilla') || osx?; end
    def blackberry?() detail?(/^Blackberry/, 'Mozilla'); end

    # IE
    def ie10?()      detail?('MSIE 10.0', 'Mozilla'); end
    def ie9?()       detail?('MSIE 9.0', 'Mozilla'); end
    def ie8?()       detail?('MSIE 8.0', 'Mozilla'); end
    def ie7?()       detail?(/^MSIE 7.0/, 'Mozilla'); end
    def ie6?()       detail?(/^MSIE 6/, 'Mozilla'); end

    def to_s()       @ua_string; end
    def inspect()    @ua.inspect; end

    # Returns the version string of the browser
    # Example: "20.0.1132.47" in "Chrome/20.0.1132.47"
    def version
      if v = ios_version
        v

      # iOS sets "Version/5.1" sometimes, it's the Mobile Safari version, not
      # the iOS version though. Usually for iOS <4
      elsif p = product?('Version')
        p[:version]

      # IE embeds its version as "Mozilla/5.0 (MSIE 9.0; x; y)"
      elsif ie?
        detail?(/^MSIE/, 'Mozilla').match(/([0-9\.]+)$/) && $1

      # Most others have it as "Chrome/20.0.3.5"
      else
        browser && browser[:version]
      end
    end

    # Returns iOS OS version.
    # iOS has a string like "CPU OS 4_3_3"
    def ios_version
      if d = detail?(/^CPU(?: iPhone)? OS/, 'Mozilla')
        d.match(/([0-9_]+)/) && $1.gsub('_', '.')
      end
    end

    # Returns the version as a number
    def version_number
      version && version.to_f
    end

    # Returns a string of classnames suitable for use in the HTML tag
    def html_class
      (%w(webkit chrome safari ios gecko opera ie linux) +
       %w(blackberry nokia android iphone ipod) +
       %w(ipad windows osx mac ie6 ie7 ie8 ie9 ie10)).map do |aspect|
        aspect  if self.send :"#{aspect}?"
      end.compact.sort.join(' ')
    end

  protected
    # Checks for, say, 'Gecko' in 'Gecko/3.9.82'
    # Returns the Product hash.
    def product?(str)
      @ua.detect { |p| p[:product] == str }
    end

    # Checks for, say, /^MSIE/ in 'Mozilla/5.0 (MSIE 9.0; x; x)'
    # Returns the exact detail name ("MSIE 9.0" in this case).
    def detail?(detail, prod=nil)
      find_match @ua do |p|
        (prod.nil? || prod == p[:product]) && has_spec(p[:details], detail)
      end
    end

    # Returns the Product that has the browser's info. Not applicable to MSIE
    # because bleargh.
    def browser
      @browser ||= (chrome? or ios? or safari? or gecko? or opera? or ie?)
    end

    # Works like Enumerable#detect, but returns the block's result, not the matching item
    def find_match(list, &blk)
      list.each do |item|
        result = blk.call item
        return result if result
      end
      nil
    end

    def has_spec(haystack, spec)
      !haystack.nil? && haystack.detect { |d| d.match(spec) }
    end
  end
end
