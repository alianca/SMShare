class NewsController < ApplicationController
  def index    
    @news = News.paginate(:page => params[:page], :per_page => 3)
  end

  def show
    @news = News.find(params[:id])
  end
end
