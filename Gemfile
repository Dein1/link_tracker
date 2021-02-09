# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

ruby '2.7.0'

gem 'json'
gem 'redis'
gem 'sinatra'

group :development, :test do
  gem 'rack-test'
  gem 'rspec'
  gem 'rubocop'
  gem 'rubocop-rspec'
end

group :development do
  gem 'shotgun'
  gem 'tux'
end

group :test do
  gem 'fakeredis', require: 'fakeredis/rspec'
end
