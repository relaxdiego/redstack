require_relative '../../../../test_helper'

describe 'RedStack::Controllers::Identity::ProjectsController' do

  before do
    @os = RedStack::Session.new(host: 'http://devstack:5000', api_version: 'v2.0', stub_openstack: true)
    @os.authenticate username: 'validuser', password: '123qwe'
    @controller = RedStack::Controllers::Identity::ProjectsController.new(@os)
  end

  it 'retrieves projects of the currently logged in user' do
    projects = @controller.find
    
    projects.must_be_instance_of Array
    projects.length.wont_be_nil
  end
     
end