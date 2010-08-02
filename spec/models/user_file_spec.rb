require 'spec_helper'

describe UserFile do
  describe "Ownership" do
    before(:each) do
      @user = User.create! :name => "Sage Darkfire", 
          :email => "sage.darkfire@example.com", :password => "123456"
      @file = UserFile.create! :owner => @user
    end
  
    it "should store the owner User" do    
      @file.reload
      @file.owner.should == @user
    end
  
    it "should be found on the User's files list" do
      @user.reload
      @user.files.should include(@file)
    end
  end
  
  describe "File Storage" do
    before(:each) do
      @tempfile = Tempfile.new("somefile.txt")
      @tempfile.write("Hello World!")
      @tempfile.flush
      
      @file = UserFile.create!(:file => @tempfile)
      @file.reload
    end
    
    it "should store the file" do
      @file.file.should be_instance_of(UserFileUploader)
    end
    
    it "should store the filename" do
      @file.filename.should include("somefile.txt")
    end
    
    it "should restore the file" do
      @file.file.file.read.should == "Hello World!"
    end
  end
end
