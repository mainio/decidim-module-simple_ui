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

Simple UI automatically applies some customizations to the Decidim UI after
installing it following the instructions listed in the installation section.

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

### Optional survey terms of service

By default, the surveys component requires the user to accept the terms of
service when they answer it. However, for most simple use cases this is
unnecessary which is why we made it optional for all questionnaires. The option
is enabled for all old surveys there may be in the database when installing this
module.

Please note that there are still valid use cases when you would need the survey
respondents to agree to the terms of service, such as:

- Collecting personal details from unregistered users, e.g. if you have a
  question for the respondent's name (or other personal details).
- Collecting extra personal details from registered users other than those
  listed in the service's privacy policy, e.g. if you are asking for the users'
  phone numbers which they would not normally provide during the registration.
- There are some legal other requirements for utilizing the survey responses,
  such as you want to publish some of the individual answers in your material,
  in which case you might need the respondents to provide you with the rights or
  a license to use that content elsewhere (e.g. on your website).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-simple_ui", github: "mainio/decidim-module-simple_ui", branch: "main"
```

And then execute:

```bash
bundle
bundle exec rails decidim_simple_ui:install:migrations
bundle exec rails db:migrate
```

## Contributing

See [Decidim](https://github.com/decidim/decidim).

## License

This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.
