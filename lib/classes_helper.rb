module ClassesHelper
  # Helper for CSS classes.
  #
  #   <% css_class :page, 'foo' %>
  #   <section class='page <%= css_class :page %>'>
  #
  def css_class(type, *classes)
    @classes ||= Hash.new { |h, k| h[k] = Array.new }
    @classes[type] += classes.join(' ').split(' ')
    @classes[type]
  end

  # Adds a body class.
  #
  #   <% body_class 'foo' %>
  #   <body class='<%= body_class %>'>
  #
  def body_class(*classes)
    css_class :body, *classes
  end
end
