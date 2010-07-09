require 'spec_helper'

describe User do
  describe "Referers" do
    before(:each) do
      @old_user = User.create! :name => "Sage Darkfire", 
          :email => "sage.darkfire@example.com", :password => "123456"
      @new_user = User.create! :name => "Flamesquawk Jellyeyes", 
          :email => "flamesquawk@example.com", :password => "123456",
          :referrer => @old_user
    end
    
    it "should be able to record the user that refered the new user" do
      @new_user.referrer.should be @old_user
    end
    
    it "should be able to find all the user an user refered" do
      @old_user.referred.should include(@new_user)
    end    
  end
end
