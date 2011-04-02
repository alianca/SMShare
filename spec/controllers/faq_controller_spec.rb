require 'spec_helper'

describe FaqController do

  describe "GET 'downloading'" do
    it "should be successful" do
      get 'downloading'
      response.should be_success
    end
  end

  describe "GET 'uploading'" do
    it "should be successful" do
      get 'uploading'
      response.should be_success
    end
  end

  describe "GET 'finances'" do
    it "should be successful" do
      get 'finances'
      response.should be_success
    end
  end

  describe "GET 'general'" do
    it "should be successful" do
      get 'general'
      response.should be_success
    end
  end

  describe "GET 'panel'" do
    it "should be successful" do
      get 'panel'
      response.should be_success
    end
  end

end
