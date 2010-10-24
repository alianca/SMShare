require 'spec_helper'

describe UserStatistic do
  before(:each) do
    @user = Factory.create :user
    @referred_user = Factory.create :user, :referrer => @user, :nickname => "other_user"
  
    tempfile1 = Tempfile.new("somefile.txt")
    tempfile1.write("A"*200)
    tempfile1.flush
    @file1 = Factory.create :user_file, :owner => @user, :file => tempfile1    
    tempfile2 = Tempfile.new("otherfile.txt")
    tempfile2.write("A"*400)
    tempfile2.flush
    @file2 = Factory.create :user_file, :owner => @user, :file => tempfile2
    @file3 = Factory.create :user_file, :owner => @referred_user, :file => tempfile2    
  
    @download1 = Factory.create :download, :file => @file1
    @download2 = Factory.create :download, :file => @file1
    @download3 = Factory.create :download, :file => @file2
    @download4 = Factory.create :download, :file => @file3
  
    @user.statistics.generate_statistics!            
    @user.reload
  end

  it "should store the number of files" do
    @user.statistics.files.should == 2
  end

  it "should store the size of the files" do
    @user.statistics.files_size.should == 600
  end

  it "should store the number of times all files were downloaded" do
    @user.statistics.downloads.should == 3
  end

  it "should store the number of times all files by referred user were downloaded" do
    @user.statistics.referred_downloads.should == 1
  end

  it "should store the bandwidth consumed by the downloads" do
    @user.statistics.bandwidth.should == 800
  end

  it "should store the revenue by the downloads" do
    @user.statistics.revenue.should == 0.0
  end

  it "should store the revenue by referred user's downloads" do
    @user.statistics.referred_revenue.should == 0.0
  end

  it "should store the date of the last update" do
    @user.statistics.updated_at.should be_instance_of(Time)
  end
end
