require 'spec_helper'

describe UserStatistic do

  before(:each) do
    @users = [@user = (Factory.create :user),
              @referred_user = (Factory.create :user, :referrer => @user, :nickname => "other_user")
             ]

    @files = [@file1 = (Factory.create :user_file, :owner => @user),
              @file2 = (Factory.create :user_file, :owner => @user),
              @file3 = (Factory.create :user_file, :owner => @referred_user)
             ]

    @downloads = [@download1 = (Factory.create :download, :file => @file1),
                  @download2 = (Factory.create :download, :file => @file1),
                  @download3 = (Factory.create :download, :file => @file2),
                  @download4 = (Factory.create :download, :file => @file3)
                 ]

    @files.each(&:needs_statistics!)

    @users.each do |u|
      u.generate_statistics!
      u.reload
    end
  end

  it "should store the number of files" do
    @user.statistics.files.should == 2
  end

  it "should store the size of the files" do
    @user.statistics.files_size.should == 84
  end

  it "should store the number of times all files were downloaded" do
    @user.statistics.downloads.should == 3
  end

  it "should store the number of times all files by referred user were downloaded" do
    @user.statistics.referred_downloads.should == 1
  end

  it "should store the bandwidth consumed by the downloads" do
    @user.statistics.bandwidth.should == 126
  end

  it "should store the revenue by the downloads" do
    (@user.statistics.revenue - 0.15).should < 0.001
  end

  it "should store the revenue by referred user's downloads" do
    (@user.statistics.referred_revenue - 0.01).should < 0.001
  end

  it "should store the date of the last update" do
    @user.statistics.updated_at.should be_instance_of(Time)
  end

end
