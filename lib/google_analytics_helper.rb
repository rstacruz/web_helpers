# Google Analytics helper.
#
# Resources:
#
#  * Event Actions guide: https://developers.google.com/analytics/devguides/collection/gajs/eventTrackerGuide#Actions
#  * Optimized Analytics helper: http://mathiasbynens.be/notes/async-analytics-snippet
#  * JSPerf for optimizations: http://jsperf.com/async-analytics-snippet
#
module GoogleAnalyticsHelper
  # Returns the Analytics ID.
  def analytics_id
    "UA-xxxxxx-xx" # override me
  end

  # Adds the default analytics tag.
  def analytics_track_pageview_tag
    analytics_tag ['_trackPageview']
  end

  # Adds a Google Analytics tracking tag.
  #
  # You can provide a custom `actions` array, which is an array of arrays.  See
  # Google's Event Actions guide for more info on event actions.
  #
  # Based on the optimized version here: http://mathiasbynens.be/notes/async-analytics-snippet
  #
  # Also see http://jsperf.com/async-analytics-snippet
  #
  #     = analytics_tag ['_trackPageview']
  #     = analytics_tag ['_setVar', 'exclusion'], ['_trackPageview']
  #
  def analytics_tag(*actions)
    id = analytics_id
    gaq = [ ['_setAccount', id] ] + actions

    script = if id
      %{
        var _gaq=#{gaq.to_json};
        (function(d,t) {
          var g=d.createElement(t),
              s=d.getElementsByTagName(t)[0];
          g.async=1;
          g.src=('https:'==location.protocol?'//ssl':'//www')+'.google-analytics.com/ga.js';
          s.parentNode.insertBefore(g,s);
        }(document,'script'));
      }.strip.gsub(/\n\s*/, '')

    else
      %{var _gaq=#{gaq.to_json}}
    end

    script = script.html_safe  if script.respond_to?(:html_safe)
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
    script = script.html_safe  if script.respond_to?(:html_safe)

    content_tag :script, script
  end
end
