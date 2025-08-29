# Decidim::SimpleUi

This module provides a clean and simpler UI for Decidim versions 0.28 and above.
There are many design decisions done with the Decidim 0.28 redesigned version
which we highly disagree with. The aim is not to break any logic within Decidim
but to provide a simplified UI that is closer to the user experience in the
previous versions (0.27 and below) while maintaining all the good parts of the
new UI, such as simplified UI structure for the participatory spaces that allows
fixing some of the accessibility issues with the previous versions (such as
repeating titles on all subpages).

## Usage

SimpleUi automatically applies some customizations to the Decidim UI after
adding it as a dependency. There are no further steps to apply the module.

The best experience is achieved together with the `decidim-nav` module available
at:

http://github.com/mainio/decidim-module-nav

The `decidim-nav` module replaces the overly complicated, hard to use and
inaccessible "mega menu" with a traditional customizable navigation bar that
website users would expect to find on any webpage. It also applies some UX
improvements to the mobile header section of the webpage.

For further improvements to the proposals submission process and some extra
features for proposals, please also see the
[`decidim-simple_proposal`](https://github.com/mainio/decidim-module-simple_proposal)
module.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-simple_ui", github: "mainio/decidim-module-simple_ui", branch: "main"
```

And then execute:

```bash
bundle
```

## Contributing

See [Decidim](https://github.com/decidim/decidim).

## License

This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.
