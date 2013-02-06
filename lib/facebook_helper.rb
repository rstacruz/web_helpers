module FacebookHelper
  # Basic script tag for including the Facebook SDK. Needed for Like buttons
  # and such. Facebook recommends this after the body tag.
  #
  #   https://developers.facebook.com/docs/reference/plugins/like/
  #
  # This uses the asynchorous version described below.
  #
  #   https://developers.facebook.com/docs/reference/javascript/
  #
  def facebook_sdk_script(options={})
    defaults = {
      appId: facebook_app_id,
      status: true,
      cookie: true,
      xfbml: true,
      locale: 'en_US'
    }

    options = defaults.merge(options)
    locale = options.delete(:locale)

    script = %{
      <div id="fb-root"></div>
      <script>
      fbAsyncInit=function(){
        FB.init(#{options.to_json})
      };
      !function(d,s,id){
        var js,fjs=d.getElementsByTagName(s)[0];
        if(!d.getElementById(id)){
          js=d.createElement(s);
          js.id=id;
          js.async=1;
          js.src='//connect.facebook.net/#{locale}/all.js';
          fjs.parentNode.insertBefore(js,fjs);
        }
      }(document,'script','facebook-jssdk');
      </script>
    }.strip.gsub(/\n\s*/, '')

    script = script.html_safe  if script.respond_to?(:html_safe)
    script
  end


  # Override me!
  def facebook_app_id
    "182974951074"
  end
end
