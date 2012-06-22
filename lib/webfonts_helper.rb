module WebfontsHelper
  # Embeds webfonts.
  #
  # More information abouth Google's webfont loader here:
  # https://developers.google.com/webfonts/docs/webfont_loader
  #
  # Common examples:
  #
  #     <!-- Load from Google -->
  #     <%= webfonts google: { families: [ 'PT Sans:400,700' ] } %>
  #     <%= webfonts google: { families: [ 'PT Sans:400,700', 'Exo:100:latin' ] } %>
  #
  # This has been optimized to cut down on some bytes.
  #
  def webfonts(config={})
    %{<script>
    WebFontConfig=#{config.to_json};
    (function(d,s){
      var w=d.createElement(s);
      w.src='//ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';
      w.async=1;
      d.getElementsByTagName(s)[0].parentNode.insertBefore(w,s);
    })(document,'script');
    </script>}.gsub(/\n\s*/, '')
  end
end

# Optimization info
# -----------------
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
# Optimized version (261 bytes):
#
#     WebFontConfig={ google: { families: [ 'Tangerine', 'Cantarell' ] }};
#     (function(d,s){var w=d.createElement(s);w.src='//ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';w.async=1;d.getElementsByTagName(s)[0].parentNode.insertBefore(w,s);})(document,'script');
