require_relative '../../../../test_helper'

include RedStack::Controllers::Identity

describe 'RedStack::Controllers::Identity::ProjectsController' do

  before do
    @os = RedStack::Session.new(host: 'http://devstack:5000', api_version: 'v2.0', stub_openstack: true)
    @os.authenticate username: 'validuser', password: '123qwe'
    @controller = ProjectsController.new(session: @os)
  end

  it 'retrieves projects of the currently logged in user' do
    projects = @controller.find
    
    projects.must_equal @controller
    projects.length.wont_be_nil
  end
  
  it 'implements the first method' do
    @controller.must_respond_to :first
  end
     
end