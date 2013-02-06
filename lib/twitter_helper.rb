module TwitterHelper
  # Basic script tag for including the Twitter SDK. Needed for Like buttons and such.
  # Twitter recommends this after the body tag.
  #
  #     <a href="https://twitter.com/share" class="twitter-share-button">Tweet</a>
  #
  def twitter_sdk_script
    script = %{
      <script>
      !function(d,s,id){
        var js,fjs=d.getElementsByTagName(s)[0];
        if(!d.getElementById(id)){
          js=d.createElement(s);
          js.id=id;
          js.src="//platform.twitter.com/widgets.js";
          fjs.parentNode.insertBefore(js,fjs);
        }
      }(document,"script","twitter-wjs");</script>
    }.strip.gsub(/\n\s*/, '')

    script = script.html_safe  if script.respond_to?(:html_safe)
    script
  end
end
