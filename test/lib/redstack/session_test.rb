require 'test_helper'

class SessionTest < MiniTest::Spec

  include RedStack::Identity::Models
  include CommonTestHelperMethods

  # Helper methods specific to these tests

  def non_admin_session
    @non_admin_session ||= new_openstack_session
    unless @non_admin_session.authenticated?
      @non_admin_session.authenticate username: non_admin_attrs[:username], password: non_admin_attrs[:password]
    end
    @non_admin_session
  end


  # Tests

  it 'authenticates against the backend' do
    session = new_openstack_session

    session.authenticate username: non_admin_attrs[:username], password: non_admin_attrs[:password]

    session.authenticated?.must_equal true
    session.tokens[:default].wont_be_nil
  end

  it 'handles invalid usernames' do
    session = new_openstack_session

    session.authenticate username: 'invaliduserhere', password: 'whatever'

    session.authenticated?.must_equal false
    session.tokens[:default].must_be_nil
  end

  it 'fetches projects' do
    projects = non_admin_session.find_projects

    projects.wont_be_nil
  end

end