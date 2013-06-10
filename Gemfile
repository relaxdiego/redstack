source 'https://rubygems.org'

# Dependencies are in redstack.gemspec
gemspec

# Putting these gems in the test group so that
# we can tell travis-ci not to build any of the
# development gems. Makes the build run faster.
group :test do
  gem 'rake'
  gem 'simplecov', '~> 0.7.0'
  gem 'coveralls', '~> 0.6.0'
  gem 'json', '~> 1.7.0'
  gem 'minitest', '~> 4.7.0'
end