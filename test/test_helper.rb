# Add the gem's lib folder to the load path
$:.unshift File.expand_path('../../lib', __FILE__)

# Add this folder to the load path
$:.unshift File.expand_path('..', __FILE__)

require 'coveralls'
Coveralls.wear!

SimpleCov.command_name 'Unit Tests'

require 'bundler/setup'
require 'minitest/autorun'
require 'redstack'
require 'vcr'

# always require last
require 'mocha/setup'

def new_openstack_session(options={})
  stub_openstack = options[:stub_openstack] || false
  RedStack::Session.new(host: 'http://devstack:5000', api_version: 'v2.0', stub_openstack: stub_openstack)
end