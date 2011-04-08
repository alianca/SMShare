class NewsController < ApplicationController
  ItemsPerPage = 3

  def index
    if params[:page]
      @page = params[:page].to_i
    else
      @page = 0
    end
    
    if (News.count % ItemsPerPage == 0)
      @last_page = News.count / ItemsPerPage - 1
    else
      @last_page = News.count / ItemsPerPage
    end
    
    @news = News.find(:sort => [:date, :desc],
                      :skip => @page*ItemsPerPage,
                      :limit => ItemsPerPage)
  end

  def read
    @news = News.find(params[:id])
  end
end
