module MapHelper
  # Show a map for a given Google map URL.
  #
  # You can provide an optional +width+ or +height+.
  #
  #     <% url = "https://maps.google.com/?ll=37.0625,-95.677068&spn=44.658568,91.318359&t=m&z=4" %>
  #     <%= google_map url, width: 200, height: 300 %>
  #
  def google_map(url, options={})
    width  = options[:width] || 300
    height = options[:height] || 300

    embed_url = "%s&output=embed" % url

    "<iframe width='#{width}' height='#{height}' frameborder='0' scrolling='no' marginheight='0' marginwidth='0' src='#{h embed_url}'></iframe>".html_safe
  end
end
