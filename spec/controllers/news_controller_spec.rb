require 'spec_helper'

describe NewsController do

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'read'" do
    it "should be successful" do
      get 'read'
      response.should be_success
    end
  end

  describe "GET 'all'" do
    it "should be successful" do
      get 'all'
      response.should be_success
    end
  end

end
