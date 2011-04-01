require 'spec_helper'

describe Category do
  describe "Relations" do
    before(:each) do
      @category = Factory.create :category
      @file = Factory.create :user_file, :categories => [@category]
    end
    
    it "should be able to find the courses on this category" do            
      @category.files.should include(@file)
    end
    
    it "should be able to be added to a course categories" do
      @file.categories.should include(@category)
    end
  end
end
