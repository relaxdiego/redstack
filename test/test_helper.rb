# Add the gem's lib folder to the load path
$:.unshift File.expand_path('../../lib', __FILE__)


# Set-up coverage reporting (local and Coveralls.com)
require 'simplecov'
require 'coveralls'
SimpleCov.command_name 'MiniTest'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter '/test/'
end

# Stuff needed for testing
require 'bundler/setup'
require 'minitest/autorun'

# Do not require these gems when running in the CI
unless ENV['CI'] || ENV['TRAVIS']
  require 'pry'
end


# Configure RedStack. It will try to look for
# redstack.yml up the directory tree
require 'redstack'
RedStack.configure

# Load test fixtures
require 'test_fixtures'
TestFixtures.load!


#================
# Helper Methods
#================

def new_openstack_session
  # For now, add an entry in your /etc/hosts file that points devstack
  # to a valid OpenStack instance. If you intend to use the mock data,
  # however, this should not matter. See redstack.yml.example for
  # information on how to use the available mock data.
  RedStack::Session.new(host: 'http://devstack:5000', api_version: 'v2.0')
end
