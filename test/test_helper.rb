# Add the gem's lib folder to the load path
$:.unshift File.expand_path('../../lib', __FILE__)

# Add this folder to the load path
$:.unshift File.expand_path('..', __FILE__)

require 'simplecov'
require 'coveralls'
# Coveralls.wear!
SimpleCov.command_name 'MiniTest'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter '/test/'
end

require 'bundler/setup'
require 'minitest/autorun'
require 'pry'

require 'redstack'
RedStack.configure

# always require last
require 'mocha/setup'


def new_openstack_session
  RedStack::Session.new(host: 'http://devstack:5000', api_version: 'v2.0')
end

require 'test_fixtures'
TestFixtures.load!

