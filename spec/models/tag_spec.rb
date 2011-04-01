require 'spec_helper'

describe Tag do
  describe "Relations" do
    it "should be able to find files with this tag" do
      user = Factory.create :user
      file1 = Factory.create :user_file, :owner => user, :tags => ["foo", "boo"]
      file2 = Factory.create :user_file, :owner => user, :tags => ["boo", "bar"]
      tag1 = Factory.create :tag, :name => "foo"
      tag2 = Factory.create :tag, :name => "boo" 
      tag3 = Factory.create :tag, :name => "bar"
      
      tag1.files.to_a.should == [file1]
      tag2.files.to_a.should == [file1, file2]
      tag3.files.to_a.should == [file2]
    end
  end
  
  describe "Consolidate" do
    before(:each) do
      user = Factory.create :user
      @file1 = Factory.create :user_file, :owner => user, :tags => ["foo", "boo"]
      @file2 = Factory.create :user_file, :owner => user, :tags => ["boo", "bar"]
      
      Tag.consolidate!.should be_true 
    end
    
    it "should create all tags for the files after a consolidate" do
      Tag.all.collect(&:name).should == ["foo", "boo", "bar"]
    end
    
    it "should remove unused tags after a consolidate" do
      @file2.destroy
      
      Tag.consolidate!.should be_true 
      Tag.all.collect(&:name).should == ["foo", "boo"]      
    end
  end
end
