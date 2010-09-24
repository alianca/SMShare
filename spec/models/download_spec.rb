require 'spec_helper'

describe Download do
  describe "User File" do
    before(:each) do
      @file = Factory.create :user_file
      @download = Factory.create :download, :file => @file
    end
  
    it "should store the file that was downlaoded" do    
      @download.reload
      @download.file.should == @file
    end
  
    it "should be found on the File's donwloads list" do
      @file.reload
      @file.downloads.should include(@download)
    end
  end
  
  describe "Downloaded At" do
    it "should fill downloaded_at with date it was created" do
      @download = Factory.create :download
      @download.downloaded_at.should be_instance_of(Time)
    end
  end
end
