module FacebookHelper
  # Basic script tag for including the Facebook SDK. Needed for Like buttons and such.
  # Facebook recommends this after the body tag.
  #
  # - https://developers.facebook.com/docs/reference/plugins/like/
  #
  # Example:
  #
  #     <div class="fb-like"
  #          data-href="http://facebook.com"
  #          data-send="false"
  #          data-layout="button_count"
  #          data-width="100"
  #          data-show-faces="true">
  #     </div>
  #
  def facebook_sdk_script
    script = %{
      <div id="fb-root"></div>
      <script>
      (function(d,s,id){
        var js,fjs=d.getElementsByTagName(s)[0];
        if(!d.getElementById(id)){
          js=d.createElement(s);
          js.id=id;
          js.src="//connect.facebook.net/en_US/all.js#xfbml=1&appId=#{facebook_app_id}";
          fjs.parentNode.insertBefore(js,fjs);
        }
      }(document,"script","facebook-jssdk"));
      </script>
    }.strip.gsub(/\n\s*/, '')

    script = script.html_safe  if script.respond_to?(:html_safe)
    script
  end

  def facebook_app_id
    "182974951074"
  end
end
