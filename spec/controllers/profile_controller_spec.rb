require 'spec_helper'
require 'authlogic/test_case'
include Authlogic::TestCase

def mock_info(stubs={})
	@mock_info ||= mock_model(Info, stubs)
end
  
describe InfoController do
	include ProfileHelper
	
	before (:each) do
		User.create!(:username => "irvinex", :id => 300, :email => "anteaterx@uci.edu", :password => "letmein", :password_confirmation => "letmein")	
		User.create!(:username => "sandiegox", :id => 400, :email => "sanx@ucsd.edu", :password => "letmein", :password_confirmation => "letmein")		
		@user1 = User.find_by_username("irvinex")
		@user2 = User.find_by_username("sandiegox")
		
		@controller = ProfileController.new
	  	@response = ActionController::TestResponse.new			
 	end
 	
  it "show should create user info if it doesn't exist" do 
    #login as user1
	activate_authlogic
	UserSession.create!(@user1)   
	Info.should_receive(:new).and_return(mock_info)
    get :show, :username => @user1.username
  end   
end
