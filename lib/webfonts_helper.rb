module WebfontsHelper
  # Embeds webfonts.
  #
  #   <%= webfonts google: { families: [ 'PT Sans:400,700' ] } %>
  #   <%= webfonts google: { families: [ 'PT Sans:400,700', 'Exo:100:latin' ] } %>
  #
  # This has been optimized to cut down on some bytes.
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
