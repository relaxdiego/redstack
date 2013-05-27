require_relative '../../../../test_helper'

include RedStack::Controllers::Identity

describe 'RedStack::Controllers::Identity::ProjectController' do

  before do
    @os = new_openstack_session
    @os.authenticate username: 'validuser', password: '123qwe'
    @controller = ProjectsController.new(session: @os).find.first
  end

  it 'has a users method' do
    @controller.users.wont_be_nil
    @controller.users.session.must_equal @os
  end
     
end