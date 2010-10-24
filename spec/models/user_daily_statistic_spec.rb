require 'spec_helper'

describe UserDailyStatistic do
  describe "History" do
    before(:each) do
      @user = Factory.create :user
      UserDailyStatistic.generate_statistics_for_user! @user
      @user.reload
    end
    
    it "should generate the statistics for every day between last month and today" do
      @user.daily_statistics.should_not be_empty
      @user.daily_statistics.order_by(:date.desc).first.should be_instance_of(UserDailyStatistic)
      @user.daily_statistics.order_by(:date.desc).first.date.should == Date.today
      @user.daily_statistics.order_by(:date.desc).last.should be_instance_of(UserDailyStatistic)
      @user.daily_statistics.order_by(:date.desc).last.date.should == 1.month.ago.beginning_of_month.to_date
    end
    
    it "should cleanup the old statistics" do
      count = @user.daily_statistics.count
      @user.daily_statistics.create(:date => 1.month.ago.beginning_of_month.to_date-1.day)
      @user.daily_statistics.count.should == count+1
      UserDailyStatistic.cleanup_old_statistics_for_user! @user
      @user.daily_statistics.count.should == count
    end
  end
  
  describe "Daily Statistics" do
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
    
      @download1 = Factory.create :download, :file => @file1, :downloaded_at => 1.day.ago
      @download2 = Factory.create :download, :file => @file1, :downloaded_at => 2.days.ago
      @download3 = Factory.create :download, :file => @file2, :downloaded_at => 1.day.ago
      @download4 = Factory.create :download, :file => @file3, :downloaded_at => 1.day.ago
    
      UserDailyStatistic.generate_statistics_for_user! @user
      @user.reload
    end
    
    it "should store the number of downloads" do
      @user.daily_statistics.where(:date => 1.day.ago.to_date).first.downloads.should == 2
    end
    
    it "should store the number of refered user's downlaods" do
      @user.daily_statistics.where(:date => 1.day.ago.to_date).first.referred_downloads.should == 1
    end
    
    it "should store the date of the last update" do
      @user.daily_statistics.first.updated_at.should be_instance_of(Time)
    end
  end
end
