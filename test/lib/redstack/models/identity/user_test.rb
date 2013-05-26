require_relative '../../../../test_helper'

include RedStack::Models::Identity

describe 'RedStack::Models::Identity:User' do

  before do
    @os = RedStack::Session.new(host: 'http://devstack:5000', api_version: 'v2.0', stub_openstack: true)
    @os.authenticate username: 'validuser', password: '123qwe'
  end
  
  it 'retrieves users' do
    users = User.find(session: @os)
    
    users.must_be_instance_of Array
    users.length.wont_be_nil
    users.first.session.must_equal @os
  end
       
end