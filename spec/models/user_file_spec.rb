require 'spec_helper'

describe UserFile do
  describe "Ownership" do
    before(:each) do
      @user = User.create! :name => "Sage Darkfire", 
          :email => "sage.darkfire@example.com", :password => "123456"
      @file = UserFile.create! :owner => @user
    end
  
    it "should be able to store the owner User" do    
      @file.reload
      @file.owner.should == @user
    end
  
    it "should be found on the User's files list" do
      @user.reload
      @user.files.should include(@file)
    end
  end
end
