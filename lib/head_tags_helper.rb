# A bunch of <head> tags you'll want to often use.
#
# Sources:
#
# * Safari HTML reference: http://developer.apple.com/library/safari/documentation/appleapplications/reference/SafariHTMLRef/Articles/MetaTags.html
# * Viewport meta tag @ MDN: https://developer.mozilla.org/en/Mobile/Viewport_meta_tag
#
# Example
#
#   %head
#     != ios_viewport_fixed_tag
#     != ios_status_bar_tag 'black'
#     != ios_touch_icon_tag '/icon.png', glossy: true
#     != ios_fullscreen_tag
#
#     != favicon_tag 'favicon.ico'
#     != canonical_link_tag 'http://foo.com/index.html'
#     != alternate_link_tag 'http://foo.com/index.gb.html', hreflang: 'de-AT'
#
# These need the TagHelper from Rails, or a similar equivalent if used outside Rails.
#
module HeadTagsHelper
  # Sets the icon to be shown when the app is pinned to the home screen.
  # You may pass `glossy: true` to make iOS put in the default gloss.
  # Make the icons in 114 x 114px.
  def ios_touch_icon_tag(url, options={})
    rel = options.delete(:glossy) ? 'apple-touch-icon' : 'apple-touch-icon-precomposed'

    tag :link, { :rel => rel, :href => url }.merge(options)
  end

  # When the app is pinned to the home screen, sets the splash screen to be
  # shown while the browser loads.
  # Make this in 640px x 920px.
  def ios_splash_tag(url, options={})
    rel = 'apple-touch-startup-image'

    tag :link, { :rel => rel, :href => url }.merge(options)
  end

  # ----

  def iphone_splash_tag(url)
    ios_splash_tag url, :media => '(max-device-width: 480px)'
  end

  def iphone_nonretina_splash_tag(url)
    ios_splash_tag url, :media => '(max-device-width: 480px) and not (-webkit-min-device-pixel-ratio: 2)'
  end

  def iphone_retina_splash_tag(url)
    ios_splash_tag url, :media => '(max-device-width: 480px) and (-webkit-min-device-pixel-ratio: 2)'
  end

  # ----

  def ipad_portrait_splash_tag(url)
    ios_splash_tag url, :media => '(min-device-width: 768px) and (orientation: portrait)'
  end

  def ipad_landscape_splash_tag(url)
    ios_splash_tag url, :media => '(min-device-width: 768px) and (orientation: landscape)'
  end

  # ----

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
  # http://developer.apple.com/library/safari/navigation/
  def ios_fullscreen_tag
    tag :link, :name => 'apple-mobile-web-app-capable', :content => 'yes'
  end

  def ios_status_bar_tag(options={})
    style = case options.delete(:style).to_s
      when 'grey' then 'default'
      when 'black' then 'black'
      when 'translucent' then 'black-translucent'
      else style
    end

    name = 'apple-mobile-web-app-status-bar-style'
    tag :meta, { :name => name, :content => style }.merge(options)
  end

  # Changes the logical window size used when displaying a page on iOS.
  #
  # Supported attributes are 'width', 'height', 'initial-scale',
  # 'minimum-scale', 'maximum-scale', 'user-scalable'.
  #
  # Supported on at least Mobile Safari and Fennec.
  #
  # See the Safari HTML reference for details.
  def viewport_tag(options={})
    style = options.map { |k, v| "#{k}=#{v}" }.join(', ')
    "<meta name='viewport' content='#{style}' />"

    tag :meta, :name => 'viewport', :content => style
  end

  def ios_viewport_tag(options={})
    defaults = {
      'width' => 'device-width',
      'initial-scale' => '1',     # Ensures it's zoomed in from the start
      'maximum-scale' => '1'      # Prevents rescale on portrait/landscape switch
    }

    viewport defaults.merge(options)
  end

  def ios_viewport_fixed_tag(options={})
    defaults = { 'user-scalable' => 'no' }
    ios_viewport defaults.merge(options)
  end

  # Declares a favicon.
  # Seems redundant, but some SEO reports say this brings up your page speed score.
  def favicon_tag(url, options={})
    mime_type = options.delete('type')
    mime_type ||= 'image/png'  if url.include?('.png')
    mime_type ||= 'image/x-icon'

    tag :link, { :rel => 'shortcut icon', href: url, type: mime_type }.merge(options)
  end

  # Link to the next page.
  def next_link_tag(url, options={})
    tag :link, { :rel => 'next', :href => url }.merge(options)
  end

  # Link to the previous page.
  def prev_link_tag(url, options={})
    tag :link, { :rel => 'prev', :href => url }.merge(options)
  end

  # Defines the canonical URL for the current page. Great for SEO.
  def canonical_link_tag(url, options={})
    tag :link, { :rel => 'canonical', :href => url }.merge(options)
  end

  # Defines an alterante URL for the current page.
  def alternate_link_tag(url, options={})
    tag :link, { :rel => 'alternate', :href => url }.merge(options)
  end

  # Hide the address bar on page load.
  #
  # Personally, I prefer to inline this rather than put in in the scripts. This
  # way, the address bar is hidden even before scripts are loaded, allowing you
  # the opportunity to (for example) show a preloader.
  #
  # http://davidwalsh.name/hide-address-bar
  def ios_hide_address_bar
    script = 'window.addEventListener("load",function() { setTimeout(function(){ window.scrollTo(0, 1); }, 0); });'
    content_tag :script, script
  end
end
