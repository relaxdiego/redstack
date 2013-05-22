# Add the gem's lib folder to the load path
$:.unshift File.expand_path("../../lib", __FILE__)

require "bundler/setup"
require "minitest/autorun"
require "mocha/setup"
require "redstack"


def mock_unscoped_access_response(options={})
  return <<-EOF
    {"access": {"token": {"expires": "2013-04-19T14:30:52Z", "id": "744c746c80bb48ed882691f825606616"}, "serviceCatalog": {}, "user": {"username": "#{options[:username] || 'john'}", "roles_links": [], "id": "85c26ecd3cd44a06bac4e7bc138faecf", "roles": [], "name": "#{options[:full_name] || 'John Doe'}"}}}
  EOF
end