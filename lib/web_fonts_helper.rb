# # Helpers: WebFonts
# Google web fonts loader.

module WebFontsHelper
  # ### web_fonts
  # Embeds web fonts.
  #
  # More information abouth Google's web font loader here:
  # https://developers.google.com/webfonts/docs/webfont_loader
  #
  # Common examples:
  #
  #     <!-- Load from Google -->
  #     <%= web_fonts google: { families: [ 'PT Sans:400,700' ] } %>
  #     <%= web_fonts google: { families: [ 'PT Sans:400,700', 'Exo:100:latin' ] } %>
  #
  # This has been optimized to cut down on some bytes.
  #
  # More examples:
  #
  #     = web_fonts typekit: { id: 'xyz123' }
  #     = web_fonts ascender: { key: 'abczxd', families: ['AscenderSans:bold,regular']
  #
  def web_fonts(config={})
    script = %{<script>
    WebFontConfig=#{config.to_json};
    (function(d,s){
      var w=d.createElement(s);
      w.src='//ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';
      w.async=1;
      var c=d.getElementsByTagName(s)[0];
      c.parentNode.insertBefore(w,c);
    })(document,'script');
    </script>}.gsub(/\n\s*/, '')
    script = script.html_safe  if script.respond_to?(:html_safe)
    script
  end
end

# ## Optimization info
#
# This optimization was inspired by the Google Analytics script optimization posted here:
# http://mathiasbynens.be/notes/async-analytics-snippet .
#
# The following optimizations were made:
#
#   * Don't set the script's 'type' attribute.
#   * Use `async = 1` instead of `async = true`.
#   * Don't smart load between http and https, just assume
#     '//ajax.googleapis.com/...' works. The drawback here is that it will not
#     work on file:/// pages.
#   * `document` and `'script'` have been bounced into the IIFE's parameters.
#
# The original Google webfont script: (417 bytes)
#
#     WebFontConfig = {
#       google: { families: [ 'Tangerine', 'Cantarell' ] }
#     };
#     (function() {
#       var wf = document.createElement('script');
#       wf.src = ('https:' == document.location.protocol ? 'https' : 'http') +
#           '://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';
#       wf.type = 'text/javascript';
#       wf.async = 'true';
#       var s = document.getElementsByTagName('script')[0];
#       s.parentNode.insertBefore(wf, s);
#     })();
#
# Optimized version (253 bytes, wrapped for clarity):
#
#     WebFontConfig={google:{families:['Tangerine','Cantarell']}};
#     (function(d,s){var w=d.createElement(s);w.src=
#     '//ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';w.async=1;var
#     c=d.getElementsByTagName(s)[0];c.parentNode.insertBefore(w,c);})
#     (document,'script');
