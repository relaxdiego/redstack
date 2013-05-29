require_relative '../../../../test_helper'

include RedStack::Identity::Models

describe 'RedStack::Identity::Models::User' do

  before do
    @os = new_openstack_session
    @os.authenticate username: 'validuser', password: '123qwe'
  end
  
  it 'retrieves users' do
    users = User.find(session: @os)
    
    users.must_be_instance_of Array
    users.length.wont_be_nil
    users.first.session.must_equal @os
  end
       
end