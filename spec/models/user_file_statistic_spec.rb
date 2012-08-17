require 'spec_helper'

describe UserFileStatistic do
  before(:each) do
    @file = Factory.create :user_file

    @download1 = Factory.create :download, :file => @file
    @download2 = Factory.create :download, :file => @file
    @file.statistics.generate_statistics!
    @file.reload
  end

  it "should store the number of download" do
    @file.statistics.downloads.should == 2
  end

  it "should store the bandwidth consumed by the download" do
    @file.statistics.bandwidth.should == 84
  end

  it "should store the date of the last update" do
    @file.statistics.updated_at.should be_instance_of(Time)
  end
end
