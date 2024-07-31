[![Gem Version](https://badge.fury.io/rb/omniauth-edlink.svg)](https://badge.fury.io/rb/omniauth-edlink)

# OmniAuth Edlink
Unofficial OmniAuth strategy for [Edlink](https://ed.link) integration via OAuth 2.0.

# Installation

Add the gem to your application's Gemfile:

```ruby
gem 'omniauth-edlink'
```
And then execute:

```
$ bundle
```

# Usage

First, you need to have Edlink account and application created. In the application Overview screen you can find
Application Keys section with "Application ID" field. This is used as a Client ID in the Omniauth strategy.
Beneath, there is a "Application Secrets" section where you can generate secret keys. Copy one of them and use them
in the strategy configuration as client secret.

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :edlink, 'your-edlink-application-key', 'your-edlink-secret-key'
end
```

Or, alternatively, if you use [Devise](https://github.com/plataformatec/devise), you can put this in the `Devise.setup` section:

```ruby
 config.omniauth :edlink,
                 'your-edlink-application-key',
                 'your-edlink-secret-key'
```

If for some reason you know the Edlink's integration id for a particular SSO request (e.g. from your application subdomain or from typed email address) and you want to take your users directly to their upstream SSO login page instead of generic Edlink login page, you can pass additional `integration_id` parameter to the redirect request, e.g.:
```ruby
redirect_to "/auth/edlink?integration_id=#{integration_id}"
```
This will redirect the user to the Edlink's SSO login page for the specified integration id.

# Contributing
1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

# License
MIT
