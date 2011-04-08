require 'spec_helper'

describe Folder do
  describe "Self Relations" do
    before(:each) do
      @root_folder = Factory.create :folder
      @child_folder1 = Factory.create :folder, :name => "foo", :parent => @root_folder
      @child_folder2 = Factory.create :folder, :name => "boo", :parent => @root_folder
    end
    
    it "should find it's childrens" do
      @root_folder.reload
      @root_folder.children.to_a.should == [@child_folder1, @child_folder2]
    end
    
    it "should find it's parent" do
      @child_folder1.parent.should == @root_folder
      @child_folder2.parent.should == @root_folder
    end
  end
  
  describe "Consolidated Path" do
    it "should generate the path" do
      @root_folder = Factory.create :folder
      @child_folder = Factory.create :folder, :name => "foo", :parent => @root_folder
      @grand_child_folder = Factory.create :folder, :name => "foo", :parent => @child_folder
      
      @root_folder.path.should == "/"
      @child_folder.path.should == "/#{@root_folder._id}/"
      @grand_child_folder.path.should == "/#{@root_folder._id}/#{@child_folder._id}/"
    end
  end
  
  describe "Files Relations" do
    before(:each) do
      @user = Factory.create :user
      Folder.destroy_all # Isolate the test from the creating of the root_folder
      @folder = Factory.create :folder, :owner => @user
      @file = Factory.create :user_file, :owner => @user, :path => "/"
    end
    
    it "should find all files in this folder" do
      @folder.files.should include(@file)
    end
    
    it "should find the folder for a file" do
      @file.folder.should == @folder
    end
  end 
end
