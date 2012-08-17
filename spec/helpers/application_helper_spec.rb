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
end
