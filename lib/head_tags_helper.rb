# A bunch of <head> tags you'll want to often use.
#
# Sources
#
# * Safari HTML reference: http://developer.apple.com/library/safari/documentation/appleapplications/reference/SafariHTMLRef/Articles/MetaTags.html
# * Viewport meta tag @ MDN: https://developer.mozilla.org/en/Mobile/Viewport_meta_tag
# * iOS startup images: http://miniapps.co.uk/blog/post/ios-startup-images-using-css-media-queries
#
# Other relevant reading
#
# * iOS stay-standalone script: https://gist.github.com/1042026
#
# Common example for web apps
#
#   %head
#     != ios_viewport_fixed_tag
#     != ios_status_bar_tag 'black'
#     != ios_touch_icon_tag '/icon.png', glossy: true
#     != ios_fullscreen_tag
#     != ios_hide_address_bar_script
#
#  For all other sites, you might want to use
#
#     != favicon_tag '/favicon.ico'
#     != canonical_link_tag 'http://foo.com/index.html'
#     != alternate_link_tag 'http://foo.com/index.gb.html', hreflang: 'de-AT'
#
# These need the TagHelper from Rails, or a similar equivalent if used outside Rails.
#
module HeadTagsHelper
  # Sets the icon to be shown when the app is pinned to the home screen.
  #
  # You may pass `glossy: true` to make iOS put in the default gloss.
  # Make the icons in 114 x 114px.
  #
  #     != ios_touch_icon_tag '/touch.png'
  #     != ios_touch_icon_tag '/touch.png', glossy: true
  #
  def ios_touch_icon_tag(url, options={})
    rel = options.delete(:glossy) ? 'apple-touch-icon' : 'apple-touch-icon-precomposed'

    tag :link, { :rel => rel, :href => url }.merge(options)
  end

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
  #
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

  # When the app is pinned to the home screen, it ensures it's loaded without
  # the Mobile Safari chrome.
  #
  # See the Mobile Safari docs.
  #
  #     != ios_fullscreen_tag
  #
  def ios_fullscreen_tag
    tag :link, :name => 'apple-mobile-web-app-capable', :content => 'yes'
  end

  # Defines the status bar style for iOS when the app is pinned to the home screen.
  #
  #     != ios_status_bar_tag 'grey'
  #     != ios_status_bar_tag 'black'
  #     != ios_status_bar_tag 'translucent'
  #
  def ios_status_bar_tag(style, options={})
    content = case style
      when 'grey' then 'default'
      when 'black' then 'black'
      when 'translucent' then 'black-translucent'
      else style
    end

    name = 'apple-mobile-web-app-status-bar-style'
    tag :meta, { :name => name, :content => contnet }.merge(options)
  end

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
  #
  def viewport_tag(options={})
    style = options.map { |k, v| "#{k}=#{v}" }.join(', ')

    tag :meta, :name => 'viewport', :content => style
  end

  # Optimize the viewport for iOS. Makes the page load with the right scale and
  # ensures portait/landscape switching doesn't affect scaling.
  #
  #     != ios_viewport_tag
  #
  def ios_viewport_tag(options={})
    defaults = {
      'width' => 'device-width',
      'initial-scale' => '1',     # Ensures it's zoomed in from the start
      'maximum-scale' => '1'      # Prevents rescale on portrait/landscape switch
    }

    viewport defaults.merge(options)
  end

  # Optimize the viewport for iOS apps. Prevents the user from pinch-zooming
  # the viewport.
  #
  #     != ios_viewport_fixed_tag
  #
  def ios_viewport_fixed_tag(options={})
    defaults = { 'user-scalable' => 'no' }
    ios_viewport defaults.merge(options)
  end

  # Declares a favicon.
  # Seems redundant, but some SEO reports say this brings up your page speed score.
  #
  #     != favicon_tag '/favicon.ico'
  #
  def favicon_tag(url='/favicon.ico', options={})
    mime_type = options.delete('type')
    mime_type ||= 'image/png'  if url.include?('.png')
    mime_type ||= 'image/x-icon'

    tag :link, { :rel => 'shortcut icon', href: url, type: mime_type }.merge(options)
  end

  # Link to the next page.
  #
  #     != next_link_tag '/?page=3'
  #
  def next_link_tag(url, options={})
    tag :link, { :rel => 'next', :href => url }.merge(options)
  end

  # Link to the previous page.
  #
  #     != next_link_tag '/?page=1'
  #
  def prev_link_tag(url, options={})
    tag :link, { :rel => 'prev', :href => url }.merge(options)
  end

  # Defines the canonical URL for the current page. Great for SEO.
  #
  #     != canonical_link_tag 'http://foo.com/page.html'
  #
  def canonical_link_tag(url, options={})
    tag :link, { :rel => 'canonical', :href => url }.merge(options)
  end

  # Defines an alternate URL for the current page.
  #
  #     != alternate_link_tag 'http://foo.com/index.gb.html', hreflang: 'de-AT'
  #
  def alternate_link_tag(url, options={})
    tag :link, { :rel => 'alternate', :href => url }.merge(options)
  end

  # Hide the address bar on page load.
  #
  # Personally, I prefer to this script to be inline rather than be put in the
  # external scripts. This way, the address bar is hidden even before scripts
  # are loaded, allowing you the opportunity to (for example) show a preloader.
  #
  # See http://davidwalsh.name/hide-address-bar
  #
  #     != ios_hide_address_bar_script
  #
  def ios_hide_address_bar_script
    script = 'window.addEventListener("load",function(){setTimeout(function(){window.scrollTo(0,1);},0);})'
    content_tag :script, script
  end
end
