# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# gem "rails"

gem 'kramdown', '~> 2.4'

gem 'rouge', '~> 4.2'

gem 'rubocop', '~> 1.65', group: :development

if RUBY_PLATFORM =~ /java/
  gem 'ruby-debug', '~> 0.11.0', groups: %i[development test]
  gem 'ruby-debug-ide', '~> 0.7.3', groups: %i[development test]
else
  gem 'debug', '~> 1.9', groups: %i[development test]
end
