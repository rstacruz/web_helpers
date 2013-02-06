module MetaHelper
  # Defines webpage metadata. This is usually <meta> tags (or sometimes <link>).
  #
  #     - meta description: 'Hello'
  #     - meta keywords: 'lol'
  #     - meta robots: 'noindex,nofollow'
  #
  #     - meta 'revisit-after' => '90 days'
  #
  # You can pass a hash, or two strings. These two are identical:
  #
  #     - meta 'description', 'Hello'
  #     - meta description: 'Hello'
  #
  # The helper figures out the correct syntax for the tags. For instance, meta
  # tags that are meant to be served as http-equiv are automatically handled.
  #
  #     - meta 'X-UA-Compatible', 'IE=edge,chrome=1'
  #     # <meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'>
  #
  #     - meta 'viewport', 'initial-scale=1'
  #     # <meta name='viewport' content='initial-scale=1'>
  #
  # Certain shortcuts are available for tags that are usually made redundant.
  #
  #     - meta url!: 'http://...'
  #     # <meta property='og:url' content='http://...'>
  #     # <meta name='twitter:url' content='http://...'>
  #     # <link rel='canonical' href='http://...'>
  #
  #     - meta title!: 'xxx'
  #     # <meta property='og:title' content='xxx'>
  #     # <meta name='twitter:title' content='xxx'>
  #
  #     - meta description!: "xxx"
  #     # <meta name="description" content="xxx">
  #     # <meta property="og:description" content="xxx">
  #
  #     - meta image!: 'http://...'
  #     # <meta name="twitter:image" content="http://...">
  #     # <meta property="og:image" content="http://...">
  #
  # Facebook's requires the following OpenGraph tags for sharing content.
  #
  #     - meta 'og:title', '...'
  #     - meta 'og:type', 'website'
  #     - meta 'og:image', '...'
  #     - meta 'og:url', '...'
  #     - meta 'og:site_name', '...'
  #     - meta 'fb:admins', 'ricostacruz'  # Only one of fb:admins or fb:app_id required
  #     - meta 'fb:app_id', 'xxxx'          
  #
  # Here's a good example:
  #
  #     - meta title!: "Fiddlesticks"
  #     - meta image!: "http://..."
  #     - meta url!: "http://..."
  #     - meta description!: "..."
  #
  #     - meta 'og:type', 'website'
  #     - meta 'og:site_name', '...'
  #     - meta 'fb:admins', 'ricostacruz'  # Only one of fb:admins or fb:app_id required
  #     - meta 'fb:app_id', 'xxxx'          
  #     - meta 'twitter:card', 'summary'
  #
  # Be sure that you're also using `#meta_tags`.
  #
  # https://dev.twitter.com/docs/cards
  # https://developers.facebook.com/docs/opengraphprotocol/#types
  #
  def meta(key=nil, val=nil)
    @meta ||= Hash.new

    if key.is_a?(Hash)
      key.each { |k, v| set_meta k, v }
    elsif !key.nil?
      set_meta key, val
    end

    @meta
  end

  # Displays meta tags.  Place me in your `<head>` on all pages.
  #
  # This converts all things placed using `#meta` to proper HTML tags.
  #
  def meta_tags
    return '' unless meta.any?

    output = []

    meta.each do |key, value|
      key = key.to_s
      value = value.join(', ')  if value.is_a?(Array)

      if opengraph_meta_key?(key)
        output.push tag('meta', :property => key, :content => value)
      elsif http_meta_key?(key)
        output.push tag('meta', :'http-equiv' => key, :content => value)
      elsif link_meta_key?(key)
        output.push tag('link', :'rel' => key, :href => value)
      else
        output.push tag('meta', :name => key, :content => value)
      end
    end

    code = output.join("\n")
    code = code.html_safe  if code.respond_to?(:html_safe)
    code
  end

private

  # Keys that are going to be http-equiv/content pairs.
  def http_meta_key?(key)
    %w[expires refresh pragma X-UA-Compatible].include?(key)
  end

  # Keys that are going to be property/content pairs. Usually Facebook tags.
  def opengraph_meta_key?(key)
    key =~ /^(og|fb|game):/
  end

  # Keys that are going to be link rel/href pairs.
  def link_meta_key?(key)
    %w[canonical prev next].include?(key)
  end

  # Sets a meta tag. Handles breaking a `key` into whatever it aliases to.
  def set_meta(key, val)
    key = key.to_s

    # Redundances
    if key == 'title!'
      @meta['og:title'] ||= val
      @meta['twitter:title'] ||= val
    elsif key == 'image!'
      @meta['og:image'] ||= val
      @meta['twitter:image'] ||= val
    elsif key == 'description!'
      @meta['description'] ||= val
      @meta['og:description'] ||= val
      @meta['twitter:description'] ||= val
    elsif key == 'url!'
      @meta['canonical'] ||= val
      @meta['og:url'] ||= val
      @meta['twitter:url'] ||= val
    else
      @meta[key] = val
    end
  end
end
