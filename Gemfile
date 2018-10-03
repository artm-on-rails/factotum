# frozen_string_literal: true

source "https://rubygems.org"

gem "rails", "~> 5.2.1"
# internationalization
gem "rails-i18n"
# postgresql driver
gem "pg"
# web server
gem "puma"
# sass for stylesheets
gem "sass-rails"
# make froms code shorter
gem "simple_form"
# compact markup
gem "slim-rails"
# javascript minimizer
gem "uglifier"
# faster click through
gem "turbolinks"
# authentication
gem "devise"
# devise internationalization
gem "devise-i18n"
# permissions
gem "cancancan"
# attachments
gem "paperclip"
# object oriented view helpers / model wrappers
gem "active_decorator"
# boot large Ruby/Rails apps faster
gem "bootsnap"
# nested association subforms
gem "cocoon"

group :development do
  # faster rails command line
  gem "spring"
  # support for Rails Panel chrome extension
  gem "meta_request"
  # preview mail in the browser instead of sending
  gem "letter_opener"
  # nice error message interface in development
  gem "better_errors"
  # necessary for REPL in better errors
  gem "binding_of_caller"
  # react on file changes
  gem "guard"
  # run tests when files change
  gem "guard-minitest"
  # pry in rails console
  gem "pry-rails"
  # Timezone info
  gem "tzinfo-data"
  # static code analyzer and code formatter
  gem "rubocop", require: false
  # Windows
  group :windows do
    gem "wdm", require: Gem.win_platform?
  end
end

group :development, :test do
  # acceptance tests
  gem "capybara"
  # generating objects for testing
  gem "factory_bot_rails"
end

group :test do
  # clean test database before each test
  gem "database_cleaner"
end
