require_relative '../../../../test_helper'

include RedStack::Controllers

describe "RedStack::Controllers::ProjectsController" do

  it "retrieves projects of the currently logged in user" do
    @os = RedStack::Session.new(host: 'http://devstack:5000', api_version: 'v2.0', stub_openstack: true)
    @os.authenticate username: 'validuser', password: '123qwe'
    
    projects = @os.projects.find
    
    projects.must_be_instance_of Array
    projects.length.wont_be_nil
  end
   
end