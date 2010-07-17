require 'spec_helper'

describe ApplicationHelper do
  describe "stylesheet and javascript for controller" do
    it "should return the controller name if it's from the app" do
      helper.stub!(:params).and_return({:controller => "home"})
      helper.stylesheet_for_controller.should == "home"
      helper.javascript_for_controller.should == "home"
    end
    
    it "should return the controller name without the nampespace if it's from devise" do
      helper.stub!(:params).and_return({:controller => "devise/registration"})
      helper.stylesheet_for_controller.should == "registration"
      helper.javascript_for_controller.should == "registration"
    end
  end
  
  describe "title" do
    it "should store the title from the view" do
      helper.title "My cute little title"
      helper.instance_variable_get("@_content_for")[:title].should == "My cute little title"
    end
        
    it "should show the title tag with the stored value" do
      helper.title "My cute little title"
      helper.title_tag.should == "<title>My cute little title</title>"
    end
    
    it "should show the default title if none is stored" do
      helper.title_tag("Default title").should == "<title>Default title</title>"
    end
  end
end