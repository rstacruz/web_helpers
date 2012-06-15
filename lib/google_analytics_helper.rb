# Google Analytics helper.
#
# Resources:
#
#  * Event Actions guide: https://developers.google.com/analytics/devguides/collection/gajs/eventTrackerGuide#Actions
#  * Optimized Analytics helper: http://mathiasbynens.be/notes/async-analytics-snippet
#  * JSPerf for optimizations: http://jsperf.com/async-analytics-snippet
#
module GoogleAnalyticsHelper
  # Adds a Google Analytics tracking tag.
  #
  # You can provide a custom `actions` array, which is an array of arrays.  See
  # Google's Event Actions guide for more info on event actions.
  #
  # Based on the optimized version here: http://mathiasbynens.be/notes/async-analytics-snippet
  #
  # Also see http://jsperf.com/async-analytics-snippet
  #
  #     = analytics_tag 'UA-28347981-1'
  #     = analytics_tag 'UA-28347981-1', ['_setVar', 'exclusion']
  #
  def analytics_tag(id, *actions)
    gaq = [ ['_setAccount', id], ['_trackPageview'], *actions ]

    script = %{
      var _gaq=#{gaq.to_json};
      (function(d) {
        var g=d.createElement(t),
            s=d.getElementsByTagName(t)[0];
        g.async=1;
        g.src=('https:'==location.protocol?'https://ssl':'http://www')+'.google-analytics.com/ga.js';
        s.parentNode.insertBefore(g,s);
      }(document,'script'));
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
    script = actions.map { |a| "_gaq.push(#{[*a].to_json});" }.join("")

    content_tag :script, script
  end
end
