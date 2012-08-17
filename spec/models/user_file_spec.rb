# -*- coding: utf-8 -*-
require 'spec_helper'

describe UserFile do
  describe "Ownership" do
    before(:each) do
      @user = Factory.create :user
      @file = Factory.create :user_file, :owner => @user
      @user.save!
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
      @file = Factory.create :user_file
      @file.reload
    end

    it "should store the file" do
      @file.filename.should_not == nil
      @file.filepath.should_not == nil
      @file.filesize.should_not == nil
      @file.filetype.should_not == nil
    end

    it "should store the filename" do
      @file.filename.should include("fake_file.txt")
    end

    it "should cache the filetype" do
      @file.filetype.should == "text/plain"
    end

    it "should cache the filesize" do
      @file.filesize.should == 42
    end
  end

  describe "Statistics" do
    before(:each) do
      @file = Factory.create :user_file
    end

    it "should have the file's statistics" do
      @file.statistics.should be_instance_of(UserFileStatistic)
    end
  end


  describe "Validations" do
    it "should require an owner" do
      file = Factory.build :user_file, :owner => nil
      file.should_not be_valid
      file.errors[:owner].should_not be_empty
    end

    it "should require a filename" do
      file = Factory.build :user_file, :filename => nil
      file.should_not be_valid
      file.errors[:filename].should_not be_empty
    end

    it "should require a filepath" do
      file = Factory.build :user_file, :filepath => nil
      file.should_not be_valid
      file.errors[:filepath].should_not be_empty
    end

    it "should require a filesize" do
      file = Factory.build :user_file, :filesize => nil
      file.should_not be_valid
      file.errors[:filesize].should_not be_empty
    end

    it "should require a filetype" do
      file = Factory.build :user_file, :filetype => nil
      file.should_not be_valid
      file.errors[:filetype].should_not be_empty
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

  describe "Tags" do
    it "should return a sentenced list of tags" do
      file = Factory.build :user_file, :tags => ["foo", "boo", "bar"]
      file.sentenced_tags.should == "foo, boo, bar"
    end

    it "should store the sentenced tags as an array" do
      file = Factory.build :user_file, :sentenced_tags => "foo, boo, bar"
      file.tags.should == ["foo", "boo", "bar"]
    end
  end
end
