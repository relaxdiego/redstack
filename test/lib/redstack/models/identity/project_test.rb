require_relative '../../../../test_helper'

include RedStack::Models::Identity

describe 'RedStack::Models::Identity:Project' do

  before do
    @os = RedStack::Session.new(host: 'http://devstack:5000', api_version: 'v2.0', stub_openstack: true)
    @os.authenticate username: 'validuser', password: '123qwe'
  end
  
  it 'retrieves projects' do
    projects = Project.find session: @os
    
    projects.must_be_instance_of Array
    projects.length.wont_be_nil
    projects.first.must_be_instance_of Project
  end
     
end