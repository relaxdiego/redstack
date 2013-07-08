require 'test_helper'

class RedStack::Identity::Resources::TokenTest < RedStack::TestBase
  include RedStack::Identity::Resources
  
  describe 'RedStack::Identity::Resources::Token' do

    def response_str
      '{"access": {"token": {"issued_at": "2013-07-08T03:51:43.718569",
       "expires": "2013-07-09T03:51:43Z", "id": "1f78f8319e2a4088a2dad7ef999f3d8b"},
       "serviceCatalog": [], "user": {"username": "validuser", "roles_links": [],
       "id": "24655bbc441843efb44c5cf058978df6", "roles": [], "name": "validuser"},
       "metadata": {"is_admin": 0, "roles": []}}}'
    end

    def response_json
      JSON.parse(response_str).deep_symbolize_keys
    end
    
    def new_token(str=response_str)
      Token.new(str)
    end
    
    
    describe '::new' do
      
      it 'returns a valid Token object' do        
        new_token.class.must_equal Token
      end
      
    end
    
    
    describe '#[:id]' do
      
      it "returns the token's id" do
        new_token[:id].must_equal response_json[:access][:token][:id]
      end
      
    end
    
    
    describe '#[:expiration]' do
      
      it "returns the token's expiration" do
        new_token[:expiration].must_equal response_json[:access][:token][:expiration]
      end
      
    end


    describe '#[:issued_at]' do
      
      it "returns the token's date of issuance" do
        new_token[:issued_at].must_equal response_json[:access][:token][:issued_at]
      end
      
    end


    describe '#[:service_catalog]' do
      
      it "returns the service catalog associated with the token" do
        new_token[:service_catalog].class.must_equal Array
        new_token[:service_catalog].must_equal response_json[:access][:serviceCatalog]
      end
      
    end


    describe '#[:user]' do
      
      it "returns the user associated with the token" do
        new_token[:user].class.must_equal Hash
        new_token[:user].must_equal response_json[:access][:user]
      end
      
    end
    
    
    describe '#[:metadata]' do
      
      it "returns the metadata associated with the token" do
        new_token[:metadata].class.must_equal Hash
        new_token[:metadata].must_equal response_json[:access][:metadata]
      end
      
    end
    
    
    describe '#default?' do
      
      it 'returns true when the token is default/unscoped' do
        json = response_json
        json[:access][:serviceCatalog] = []
        
        new_token(JSON.generate(json)).default?.must_equal true
      end

      it 'returns false when the token is scoped' do
        json = response_json
        json[:access][:serviceCatalog] = [{
            endpoints: 
              [{
                adminURL: "http://example", 
                region: "RegionOne", 
                internalURL: "http://example", 
                id: "2f835cf8ce0f4da9ac96ad2d5f7218e0", 
                publicURL: "http://example"
              }], 
            endpoints_links: [], 
            type: "compute", 
            name: "nova"
           }]
        
        new_token(JSON.generate(json)).default?.must_equal false
      end
      
    end
    
    
    describe '#expired?' do
      
      it 'returns true when the token is expired' do
        json = response_json
        json[:access][:token][:expires] = 1.hour.ago.utc
        
        new_token(JSON.generate(json)).expired?.must_equal true
      end

      it 'returns false when the token is not expired' do
        json = response_json
        json[:access][:token][:expires] = 1.hour.from_now.utc
        
        new_token(JSON.generate(json)).expired?.must_equal false
      end

      
    end
    
  end
  
end