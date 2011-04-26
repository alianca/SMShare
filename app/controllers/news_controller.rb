class NewsController < ApplicationController

  before_filter :set_active

  def set_active
    @active_footer = :news
  end

  def index    
    @news = News.paginate(:page => params[:page], :per_page => 3)
  end

  def show
    @news = News.find(params[:id])
  end
end
