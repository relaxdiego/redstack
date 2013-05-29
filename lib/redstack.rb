require 'net/http'
require 'json'
require 'faraday'
require 'vcr'

# VCR.configure do |c|
#   c.cassette_library_dir = File.expand_path('../../test/fixtures/openstack', __FILE__)
#   c.hook_into :faraday
# end

require 'redstack/version'
require 'redstack/session'

require 'redstack/identity/models/project'
require 'redstack/identity/models/user'

require 'redstack/identity/controllers/projects_controller'
require 'redstack/identity/controllers/project_controller'
require 'redstack/identity/controllers/users_controller'