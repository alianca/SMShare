require 'spec_helper'

describe User do
  describe "Referers" do
    before(:each) do
      @old_user = Factory.create :user, :name => "Sage Darkfire", 
          :email => "sage.darkfire@example.com"
      @new_user = Factory.create :user, :name => "Flamesquawk Jellyeyes", 
          :email => "flamesquawk@example.com", :referrer => @old_user
    end
    
    it "should be able to record the user that refered the new user" do
      @new_user.reload # just to make sure
      @new_user.referrer.should == @old_user
    end
    
    it "should be able to find all the user an user refered" do
      @old_user.reload # just to make sure
      @old_user.referred.should include(@new_user)
    end
  end
  
  describe "Authentication" do
    before(:each) do
      @user = Factory.create :user, :name => "Robin Sage", :nickname => "sage",
          :email => "sage@ihaveyoursecrets.com", :password => "123456"
    end
    
    it "should be able to login given a valid e-mail and password" do
      User.find_for_authentication(:email => "sage@ihaveyoursecrets.com").should be_valid_password("123456")
    end
    
    it "should be able to login given a valid username and password" do
      User.find_for_authentication(:email => "sage").should be_valid_password("123456")
    end
  end
  
  describe "Statistics" do
    before(:each) do
      @user = Factory.create :user
    end
    
    it "should have the user's statistics" do
      @user.statistics.should be_instance_of(UserStatistic)
    end
    
    it "should have the user's daily statistics" do
      @user.daily_statistics.should be_instance_of(Array)
    end
  end
  
  describe "Validations" do
    it "should require a name" do
      user = Factory.build :user, :name => nil
      user.should_not be_valid
      user.errors[:name].should_not be_empty
    end
    
    it "should require an email" do
      user = Factory.build :user, :email => nil
      user.should_not be_valid
      user.errors[:email].should_not be_empty
    end
    
    it "should require the email to be unique" do
      old_user = Factory.create :user, :email => "goodolduser@example.com"
      new_user = Factory.build :user, :email => "goodolduser@example.com"
      new_user.should_not be_valid
      new_user.errors[:email].should_not be_empty
    end
    
    it "should require the email to be valid" do
      user = Factory.build :user, :email => "notanemail.com"
      user.should_not be_valid
      user.errors[:email].should_not be_empty
    end
    
    it "should require a password" do
      user = Factory.build :user, :password => nil
      user.should_not be_valid
      user.errors[:password].should_not be_empty
    end
    
    it "should require the password to be between 5 and 42 characters long" do
      user = Factory.build :user, :password => "abcd"
      user.should_not be_valid
      user.errors[:password].should_not be_empty
      
      user = Factory.build :user, :password => "1234567890123456789012345678901234567890123"
      user.should_not be_valid
      user.errors[:password].should_not be_empty
    end
    
    it "should require the password confirmation to be the same as the password" do
      user = Factory.build :user, :password => "123456", :password_confirmation => "124356"
      user.should_not be_valid
      user.errors[:password].should_not be_empty
    end
    
    it "should require a nickname" do
      user = Factory.build :user, :nickname => nil
      user.should_not be_valid
      user.errors[:nickname].should_not be_empty
    end
    
    it "should require the nickname to be unique" do
      old_user = Factory.create :user, :nickname => "goodolduser"
      new_user = Factory.build :user, :nickname => "goodolduser"
      new_user.should_not be_valid
      new_user.errors[:nickname].should_not be_empty
    end
    
    it "should require the nickname to be between 4 and 32 characters long" do
      user = Factory.build :user, :nickname => "abc"
      user.should_not be_valid
      user.errors[:nickname].should_not be_empty
      
      user = Factory.build :user, :nickname => "123456789012345678901234567890123"
      user.should_not be_valid
      user.errors[:nickname].should_not be_empty
    end
    
    it "should require the user to accept the terms" do
      user = Factory.build :user, :accepted_terms => false
      user.should_not be_valid
      user.errors[:accepted_terms].should_not be_empty
    end    
  end
end
