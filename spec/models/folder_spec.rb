require 'spec_helper'

describe Folder do
  describe "Self Relations" do
    before(:each) do
      @u = Factory.create :user

      @root_folder = Factory.create :folder, :owner => @u
      @child_folder1 = Factory.create :folder, :name => "foo", :parent => @root_folder, :owner => @u
      @child_folder2 = Factory.create :folder, :name => "boo", :parent => @root_folder, :owner => @u
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
      @u = Factory.create :user

      @root_folder = Factory.create :folder, :owner => @u
      @child_folder = Factory.create :folder, :name => "foo", :parent => @root_folder, :owner => @u
      @grand_child_folder = Factory.create :folder, :name => "foo", :parent => @child_folder, :owner => @u

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
      @file = Factory.create :user_file, :owner => @user
      @file.folder = @folder
    end

    it "should find all files in this folder" do
      @folder.files.to_a.should include(@file)
    end

    it "should find the folder for a file" do
      @file.folder.should == @folder
    end
  end

  describe "Paginate" do
    before(:each) do
      @user = Factory.create :user
      5.times do |i|
        Factory.create :folder, :name => "Foo", :parent => @user.root_folder, :owner => @user
      end
      5.times do |i|
        Factory.create :user_file, :owner => @user
      end
    end

    it "should be able to paginate bringing the folder first" do
      page = @user.root_folder.paginate(1, 10).to_a
      folders = page[0..4]
      files = page[5..9]
      folders.map{|f| f.instance_of? Folder}.reduce{|a,b| a && b}.should == true
      files.map{|f| f.instance_of? UserFile}.reduce{|a,b| a && b}.should == true
    end
  end
end
