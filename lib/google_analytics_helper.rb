# Google Analytics helper.
#
# Resources:
#
#  * Event Actions guide: https://developers.google.com/analytics/devguides/collection/gajs/eventTrackerGuide#Actions
#
module GoogleAnalyticsHelper
  # Adds a Google Analytics tracking tag.
  #
  # You can provide a custom `actions` array, which is an array of arrays.  See
  # Google's Event Actions guide for more info on event actions.
  #
  #     = analytics_tag 'UA-28347981-1'
  #     = analytics_tag 'UA-28347981-1', ['_trackEvent', 'Download']
  #
  def analytics_tag(id, *actions)
    script = %{
      var _gaq = _gaq || [];
      _gaq.push(['_setAccount', #{id.to_json}]);
      _gaq.push(['_trackPageview']);
      #{actions.map { |a| "_gaq.push(#{[*a].to_json});" }}

      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })();
    }.strip.gsub(/\n\s*/, '')

    content_tag :script, script
  end

  # Run some Google Analytics actions. Perfect for marking pages in a
  # conversion funnel, for example. When using this, make sure you also have
  # analytics_tag elsewhere on the page.
  #
  # See Google's Event Actions guide for more info.
  #
  #     = analytics_action_tag ['_trackEvent', 'Videos', 'Play', 'Gone With The Wind']
  #     = analytics_action_tag ['_trackEvent', 'Download'], ['_trackEvent', 'Play']
  #
  def analytics_action_tag(*actions)
    script = %{
      var _gaq = _gaq || [];
      #{actions.map { |a| "_gaq.push(#{[*a].to_json});" }}
    }.strip.gsub(/\n\s*/, '')

    content_tag :script, script
  end
end
