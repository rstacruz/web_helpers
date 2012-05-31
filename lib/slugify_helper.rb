module SlugifyHelper
  extend self

  # Turns a string into a slug.
  #
  #     slugify '50% off for a Dinner for Two'
  #     #=> '50-off-for-a-dinner-for-two'
  #
  #     slugify '50% off for a Dinner for Two', max: 5
  #     #=> '50-off'
  #
  #     slugify '50% off for a Dinner for Two', space: '_'
  #     #=> '50_off_for_a_dinner_for_two'
  #
  def slugify(str, options={})
    max = options[:max] || 80
    space = options[:space] || '-'
    str.downcase.scan(/[A-Za-z0-9]+/).join(' ')[0..max].gsub(' ', space)
  end
end
