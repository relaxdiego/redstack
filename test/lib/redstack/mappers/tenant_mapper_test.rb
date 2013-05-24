require_relative '../../../test_helper'
 
describe "RedStack::Mappers::TenantMapper" do

  it "retrieves tenants of the currently logged in user" do
    @os = RedStack::Session.new(host: 'http://devstack:5000', api_version: 'v2.0', stub_openstack: true)
    @os.authenticate username: 'validuser', password: '123qwe'
    
    tenants = @os.tenants.get_all
    
    tenants.wont_be_nil
    tenants.must_equal @os.tenants
    tenants.length.must_equal 1
  end
   
end