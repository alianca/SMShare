class NewsController < ApplicationController
  def index
    @news = News.find(:sort => [:date, :desc], :limit => 3)
  end

  def read
    @news = News.find(params[:id])
  end

  def all
    @news = News.all
  end

end
