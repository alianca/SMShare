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
  describe "Authentication" do
    before(:each) do
      @user = User.create! :name => "Robin Sage", :nickname => "sage",
              :email => "sage@ihaveyoursecrets.com", :password => "123456"
    end
    
    it "should be able to login given a valid e-mail and password" do
      User.find_for_authentication(:email => "sage@ihaveyoursecrets.com").valid_password?("123456").should be true
    end
    
    it "should be able to login given a valid username and password" do
      User.find_for_authentication(:email => "sage").valid_password?("123456").should be true
    end
    
  end
end
