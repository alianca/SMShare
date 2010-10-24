require 'spec_helper'

describe UserFileStatistic do
  before(:each) do
    tempfile = Tempfile.new("somefile.txt")
    tempfile.write("A"*200)
    tempfile.flush
    @file = Factory.create :user_file, :file => tempfile
  
    @download1 = Factory.create :download, :file => @file
    @download2 = Factory.create :download, :file => @file
  
    @file.statistics.generate_statistics!            
    @file.reload
  end

  it "should store the number of download" do
    @file.statistics.downloads.should == 2
  end
  
  it "should store the bandwidth consumed by the download" do
    @file.statistics.bandwidth.should == 400
  end
  
  it "should store the date of the last update" do
    @file.statistics.updated_at.should be_instance_of(Time)
  end
end
