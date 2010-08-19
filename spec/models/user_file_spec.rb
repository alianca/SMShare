require 'spec_helper'

describe UserFile do
  describe "Ownership" do
    before(:each) do
      @user = Factory.create :user
      @file = Factory.create :user_file, :owner => @user
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
      
      @file = Factory.create :user_file, :file => @tempfile
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
    
    it "should cache the filetype" do
      @file.filetype.should == "binary/octet-stream"
    end
    
    it "should cache the filesize" do
      @file.filesize.should == 12.bytes
    end
  end
  
  describe "Validations" do
    it "should require an owner" do
      file = Factory.build :user_file, :owner => nil
      file.should_not be_valid
      file.errors[:owner].should_not be_empty
    end
    
    it "should require a file" do
      file = Factory.build :user_file, :file => nil
      file.should_not be_valid
      file.errors[:file].should_not be_empty
    end
    
    it "should require a description" do
      file = Factory.build :user_file, :description => nil      
      file.should_not be_valid
      file.errors[:description].should_not be_empty
    end
    
    it "should ignore the default description" do
      file = Factory.build :user_file, :description => "Digite uma descrição objetiva para seu arquivo."
      file.should_not be_valid
      file.errors[:description].should_not be_empty
      file.description.should be_nil
    end
  end
end
