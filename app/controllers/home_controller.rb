class HomeController < ApplicationController
  def index
    @news = News.last
  end
end
