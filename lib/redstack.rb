require 'net/http'
require 'json'
require 'faraday'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = File.expand_path('../../test/fixtures/openstack', __FILE__)
  c.hook_into :faraday
end

require 'redstack/version'
require 'redstack/session'
require 'redstack/identity'