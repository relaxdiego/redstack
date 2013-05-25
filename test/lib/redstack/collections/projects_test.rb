require_relative '../../../test_helper'

include RedStack::Collections

describe "RedStack::Collections::Projects" do

  it "retrieves projects of the currently logged in user" do
    @os = RedStack::Session.new(host: 'http://devstack:5000', api_version: 'v2.0', stub_openstack: true)
    @os.authenticate username: 'validuser', password: '123qwe'
    projects = Projects.new(@os)

    projects.find_all.must_equal projects
    projects.length.must_equal 1
  end
   
end