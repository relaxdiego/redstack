# Add the gem's lib folder to the load path
$:.unshift File.expand_path('../../lib', __FILE__)

# Add this folder to the load path
$:.unshift File.expand_path('..', __FILE__)

require 'bundler/setup'
require 'minitest/autorun'
require 'redstack'
require 'vcr'

# always require last
require 'mocha/setup'