module WebfontsHelper
  # <%= webfonts google: { families: [ 'PT Sans:400,700' ] } %>
  # <%= webfonts google: { families: [ 'PT Sans:400,700', 'Exo:100:latin' ] } %>
  def webfonts(config={})
    %{<script>
    WebFontConfig = #{config.to_json};
    (function() {
      var wf = document.createElement('script');
      wf.src = ('https:' == document.location.protocol ? 'https' : 'http') +
          '://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';
      wf.type = 'text/javascript';
      wf.async = 'true';
      var s = document.getElementsByTagName('script')[0];
      s.parentNode.insertBefore(wf, s);
    })();
    </script>}.gsub(/\n\s*/, '')
  end
end
