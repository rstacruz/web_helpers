# # HeadTagsHelper
# A bunch of <head> tags you'll want to often use.
#
# ## Sources
#
# * Safari HTML reference: http://developer.apple.com/library/safari/documentation/appleapplications/reference/SafariHTMLRef/Articles/MetaTags.html
# * Viewport meta tag @ MDN: https://developer.mozilla.org/en/Mobile/Viewport_meta_tag
# * iOS startup images: http://miniapps.co.uk/blog/post/ios-startup-images-using-css-media-queries
#
# ## Other relevant reading
#
# * iOS stay-standalone script: https://gist.github.com/1042026
#
# ## Common example for web apps
#
#   %head
#     != ios_viewport_fixed_tag
#     != ios_status_bar_tag 'black'
#     != ios_touch_icon_tag '/icon.png', glossy: true
#     != ios_fullscreen_tag
#     != mobile_hide_address_bar_script
#
#  For all other sites, you might want to use
#
#     != favicon_tag '/favicon.ico'
#     != canonical_link_tag 'http://foo.com/index.html'
#     != alternate_link_tag 'http://foo.com/index.gb.html', hreflang: 'de-AT'
#
# These need the TagHelper from Rails, or a similar equivalent if used outside Rails.
#
# ## Retina stuff
#
#     != favicon_tag '/favicon.ico'
#     != favicon_tag '/favicon-32.png', sizes: '32x32'
#     != favicon_tag '/favicon-64.png', sizes: '64x64'
#     != favicon_tag '/favicon-128.png', sizes: '128x128'
#
#     != ios_touch_icon_tag '/touch.png'
#     != ios_touch_icon_tag '/touch-ipad.png', sizes: '72x72'
#     != ios_touch_icon_tag '/touch-iphone4.png', sizes: '114x114'
#     != ios_touch_icon_tag '/touch.png', glossy: true

module HeadTagsHelper

  # ### ios_touch_icon_tag
  # Sets the icon to be shown when the app is pinned to the home screen.
  #
  # You may pass `glossy: true` to make iOS put in the default gloss.
  # Make the icons in 114 x 114px.
  #
  #     != ios_touch_icon_tag '/touch.png'
  #     != ios_touch_icon_tag '/touch-ipad.png', sizes: '72x72'
  #     != ios_touch_icon_tag '/touch-iphone4.png', sizes: '114x114'
  #     != ios_touch_icon_tag '/touch.png', glossy: true

  def ios_touch_icon_tag(url, options={})
    rel = options.delete(:glossy) ? 'apple-touch-icon' : 'apple-touch-icon-precomposed'

    tag :link, { :rel => rel, :href => url }.merge(options)
  end

  # ### ios_splash_tag
  # When the app is pinned to the home screen, sets the splash screen to be
  # shown while the browser loads.
  # Make this in 640px x 920px (or 320 x 460 for non retina).
  #
  #     != ios_splash_tag '/splash.png'
  #
  # Or even better:
  #
  #     != iphone_splash_tag '/splash_iphone.png'
  #     != iphone_retina_splash_tag '/splash_iphone@2x.png'
  #
  #     != ipad_portrait_splash_tag '/splash_ipad_portrait.png'
  #     != ipad_landscape_splash_tag '/splash_ipad_landscape.png'
  #
  #     != ipad_retina_portrait_splash_tag '/splash_ipad_portrait@2x.png'
  #     != ipad_retina_landscape_splash_tag '/splash_ipad_landscape@2x.png'

  def ios_splash_tag(url, options={})
    rel = 'apple-touch-startup-image'

    tag :link, { :rel => rel, :href => url }.merge(options)
  end

  def iphone_splash_tag(url)
    ios_splash_tag url, :media => '(max-device-width: 480px)'
  end

  def iphone_nonretina_splash_tag(url)
    ios_splash_tag url, :media => '(max-device-width: 480px) and not (-webkit-min-device-pixel-ratio: 2)'
  end

  def iphone_retina_splash_tag(url)
    ios_splash_tag url, :media => '(max-device-width: 480px) and (-webkit-min-device-pixel-ratio: 2)'
  end

  def ipad_portrait_splash_tag(url)
    ios_splash_tag url, :media => '(min-device-width: 768px) and (orientation: portrait)'
  end

  def ipad_landscape_splash_tag(url)
    ios_splash_tag url, :media => '(min-device-width: 768px) and (orientation: landscape)'
  end

  def ipad_nonretina_portrait_splash_tag(url)
    ios_splash_tag url, :media => '(min-device-width: 768px) and (orientation: portrait) and not (-webkit-min-device-pixel-ratio: 2)'
  end

  def ipad_nonretina_landscape_splash_tag(url)
    ios_splash_tag url, :media => '(min-device-width: 768px) and (orientation: landscape) and not (-webkit-min-device-pixel-ratio: 2)'
  end

  def ipad_retina_portrait_splash_tag(url)
    ios_splash_tag url, :media => '(min-device-width: 768px) and (orientation: portrait) and (-webkit-min-device-pixel-ratio: 2)'
  end

  def ipad_retina_landscape_splash_tag(url)
    ios_splash_tag url, :media => '(min-device-width: 768px) and (orientation: landscape) and (-webkit-min-device-pixel-ratio: 2)'
  end

  # ### ios_fullscreen_tag
  # When the app is pinned to the home screen, it ensures it's loaded without
  # the Mobile Safari chrome.
  #
  # See the Mobile Safari docs.
  #
  #     != ios_fullscreen_tag

  def ios_fullscreen_tag
    tag :meta, :name => 'apple-mobile-web-app-capable', :content => 'yes'
  end

  # ### ios_status_bar_tag
  # Defines the status bar style for iOS when the app is pinned to the home screen.
  #
  #     != ios_status_bar_tag 'grey'
  #     != ios_status_bar_tag 'black'
  #     != ios_status_bar_tag 'translucent'

  def ios_status_bar_tag(style, options={})
    content = case style
      when 'grey' then 'default'
      when 'black' then 'black'
      when 'translucent' then 'black-translucent'
      else style
    end

    name = 'apple-mobile-web-app-status-bar-style'
    tag :meta, { :name => name, :content => content }.merge(options)
  end

  # ### viewport_tag
  # Changes the logical window size used when displaying a page on iOS.
  #
  # Supported attributes are 'width', 'height', 'initial-scale',
  # 'minimum-scale', 'maximum-scale', 'user-scalable'.
  #
  # Supported on at least Mobile Safari and Fennec.
  #
  # See the Safari HTML reference for details.
  #
  #     != viewport_tag 'width' => 'device-width', 'initial-scale' => '2.4'

  def viewport_tag(options={})
    style = options.map { |k, v| "#{k}=#{v}" }.join(', ')

    tag :meta, :name => 'viewport', :content => style
  end

  # ### ios_viewport_tag
  # Optimize the viewport for iOS. Makes the page load with the right scale and
  # ensures portait/landscape switching doesn't affect scaling.
  #
  #     != ios_viewport_tag

  def ios_viewport_tag(options={})
    defaults = {
      'width' => 'device-width',
      'initial-scale' => '1',     # Ensures it's zoomed in from the start
      'maximum-scale' => '1'      # Prevents rescale on portrait/landscape switch
    }

    viewport_tag defaults.merge(options)
  end

  # ### ios_viewport_fixed_Tag
  # Optimize the viewport for iOS apps. Prevents the user from pinch-zooming
  # the viewport.
  #
  #     != ios_viewport_fixed_tag

  def ios_viewport_fixed_tag(options={})
    defaults = { 'user-scalable' => 'no' }
    ios_viewport_tag defaults.merge(options)
  end

  # ### favicon_tag
  # Declares a favicon.
  # Seems redundant, but some SEO reports say this brings up your page speed score.
  #
  #     != favicon_tag '/favicon.ico'
  #     != favicon_tag '/favicon-32.png', sizes: '32x32'
  #     != favicon_tag '/favicon-64.png', sizes: '64x64'
  #     != favicon_tag '/favicon-128.png', sizes: '128x128'

  def favicon_tag(url='/favicon.ico', options={})
    mime_type = options.delete('type')
    mime_type ||= 'image/png'  if url.include?('.png')
    mime_type ||= 'image/x-icon'

    tag :link, { :rel => 'shortcut icon', href: url, type: mime_type }.merge(options)
  end

  # ### next_link_tag
  # Link to the next page.
  #
  #     != next_link_tag '/?page=3'

  def next_link_tag(url, options={})
    tag :link, { :rel => 'next', :href => url }.merge(options)
  end

  # ### prev_link_tag
  # Link to the previous page.
  #
  #     != next_link_tag '/?page=1'

  def prev_link_tag(url, options={})
    tag :link, { :rel => 'prev', :href => url }.merge(options)
  end

  # ### canonical_link_tag
  # Defines the canonical URL for the current page. Great for SEO.
  #
  #     != canonical_link_tag 'http://foo.com/page.html'

  def canonical_link_tag(url, options={})
    tag :link, { :rel => 'canonical', :href => url }.merge(options)
  end

  # ### alternate_link_tag
  # Defines an alternate URL for the current page.
  #
  #     != alternate_link_tag 'http://foo.com/index.gb.html', hreflang: 'de-AT'

  def alternate_link_tag(url, options={})
    tag :link, { :rel => 'alternate', :href => url }.merge(options)
  end

  # ### mobile_hide_address_bar_script
  # Hide the address bar on page load.
  #
  # Personally, I prefer to this script to be inline rather than be put in the
  # external scripts. This way, the address bar is hidden even before scripts
  # are loaded, allowing you the opportunity to (for example) show a preloader.
  #
  # See http://davidwalsh.name/hide-address-bar
  #
  # This uses the Normalized address bar hiding script for iOS & Android, (c)
  # @scottjehl, MIT License. See: https://github.com/scottjehl/Hide-Address-Bar
  #
  #     != mobile_hide_address_bar_script

  def mobile_hide_address_bar_script
    script = %[
      (function(a){var b=a.document;if(!location.hash&&a.addEventListener){
      window.scrollTo(0,1);var c=1,d=function(){return a.pageYOffset||b.compatMode
      ==="CSS1Compat"&&b.documentElement.scrollTop||b.body.scrollTop||0},e=
      setInterval(function(){b.body&&(clearInterval(e),c=d(),a.scrollTo(0,c
      ===1?0:1))},15);a.addEventListener("load",function(){setTimeout(function
      (){d()<20&&a.scrollTo(0,c===1?0:1)},0)})}})(this)
    ].strip.gsub(/\n\s*/, '')

    script = script.html_safe  if script.respond_to?(:html_safe)
    content_tag :script, script
  end

  # ### ie_edge_tag
  # Force IE to render with the latest renderer version it can use.
  # Note that this is discouraged; it's best to use ie_version with the
  # specific versions of IE you've tested with.
  #
  # See http://www.alistapart.com/articles/beyonddoctype
  #
  # Also see http://www.chromium.org/developers/how-tos/chrome-frame-getting-started
  #
  #     != ie_edge_tag

  def ie_edge_tag
    ie_version_tag 'IE=edge,chrome=1'
  end

  # ### ie_version_tag
  # Force IE to render with a specific version.
  #
  # As of time of writing, you may specify 5, 7, 8, 9, 10, edge, or EmulateIE7 for IE.
  #
  # http://msdn.microsoft.com/en-us/library/cc288325(v=VS.85).aspx
  #
  #     != ie_version_tag 'IE=8'
  #     != ie_version_tag 'IE=8, IE=9, IE=10, chrome=1'

  def ie_version_tag(content)
    tag :meta, :'http-equiv' => 'X-UA-Compatible', :content => content
  end
end
