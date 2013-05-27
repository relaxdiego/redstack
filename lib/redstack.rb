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

require 'redstack/models/identity/project'
require 'redstack/models/identity/user'

require 'redstack/controllers/identity/projects_controller'
require 'redstack/controllers/identity/project_controller'
require 'redstack/controllers/identity/users_controller'