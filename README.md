Web helpers
===========

A bunch of Ruby web helpers for you to use and enjoy. Works in: Rails,
[Sinatra][sin]*, [Padrino][pad], [Middleman][mm], or just plain old Ruby*.

* = Some helpers need the `tag` and `content_tag` helper. Rails, ActionView, et 
  al, already have these, but otherwise, get them from [Padrino Helpers][ph].

[sin]: http://sinatrarb.com
[pad]: http://www.padrinorb.com
[mm]: http://www.middlemanapp.com
[ph]: https://rubygems.org/gems/padrino-helpers

How to use me
-------------

Drop the files into your project, stir, enjoy. I recommend doing it like this.
This way, the helpers become a part of your project and you'd be free to change
them to your liking.

How to use me if you're lazy (and like Bundler)
-----------------------------------------------

Eh. Wat. Okay.

``` ruby
# Gemfile
gem 'web_helpers', github: 'rstacruz/web_helpers'

# In your app:
require 'head_tags_helper'
```
