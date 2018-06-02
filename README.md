Heartwood::Icons
==========

[![Build Status](https://travis-ci.org/seancdavis/heartwood-icons.svg?branch=master)](https://travis-ci.org/seancdavis/heartwood-icons)

Heartwood's icons gem provides a simple DSL for uploading assets directly to Amazon S3.

Installation
----------

Add this line to your application's Gemfile:

```ruby
gem 'heartwood-icons'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heartwood-icons

Usage
----------

### Generator

Hearwood's main feature is its rails generator, which builds an SVG icon sprite from a series of icons in your project.

It expects your icons to conform to a specific structure:

- Icons should be placed in `app/assets/images/icons`. No other directories are searched for icons.
- Icon files should use `.svg` extension. The generator only looks for SVG files in the icons directory.
- The content of the icon must exist within top-level groups (`<g>` elements).
- The artwork should be constrained to a `256px` by `256px` space. (You can build in padding using the `transform` attribute).

_See the `spec/support/example_icon.svg` for an example of a raw icon._

When you're ready to build your sprite, you can do so from the command line:

    $ bundle exec rails generate heartwood:icons:sprite

This creates the sprite file at `app/assets/images/icons.svg`.

### View Helper

To render an icon in your app, use the `heartwood_icon` helper. This will render the SVG inline, which provides the benefit of not making an additional requestion to the server.

```html+erb
<%= heartwood_icon 'icon_name' %>
```

Replace `icon_name` with the filename of the icon you wish to render (without the `.svg` extension). you may also pass a hash of options, including:

- `class`: Classes to add to the outer `<svg>` element.
- `size`: Adds `hw-icon-#{size}` class to the outer `<svg>` element.
- `color`: Adds `hw-icon-#{color}` class to the outer `<svg>` element.

#### Custom Classes

For example, to add your own class to a user icon, it may look something like this:

```html+erb
<%= heartwood_icon 'user', class: 'my-user-icon' %>
```

#### Sizes

Sizes follow an `8px` base scale from `8px` to `256px`. The value to pass the explicit pixel value at which you'd like the icon to be rendered. So, for example, if you want a `128px` icon, you may have something like this:

```html+erb
<%= heartwood_icon 'checkmark', size: 128 %>
```

The default size does not follow this convention, but is instead set to `1rem`.

_Note: Icons are assumed to be built upon a square space, so when you set the size, you are setting the height and width of the outer `<svg>` element._

#### Colors

There are a default set of color options available, using some basic sass colors, as follows:

```scss
$heartwood-icon-colors: (
  blue: blue,
  cyan: cyan,
  green: green,
  magenta: magenta,
  red: red,
  yellow: yellow
) !default;
```

You can override these values by defining your own `$heartwood-icon-colors` map in your stylesheet **before** importing the `heartwood/icons` stylesheet.

From there, the color you use simply becomes the name of the key in the map:

```html+erb
<%= heartwood_icon 'delete', color: 'red' %>
```

Development
----------

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

Contributing
----------

Bug reports and pull requests are welcome on GitHub at https://github.com/seancdavis/heartwood-icons. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

License
----------

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

Code of Conduct
----------

Everyone interacting in the Heartwood::Icons project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/seancdavis/heartwood-icons/blob/master/CODE_OF_CONDUCT.md).
