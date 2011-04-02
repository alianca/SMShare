class Admin::NewsController < ApplicationController
  
  before_filter :require_admin!
  uses_tiny_mce :only => [:index, :new, :edit]
  
  def index
    
  end
  
  def show
  
  end
  
  def new
    
  end
  
  def create
    short= params['news']['short']
    full = params['news']['full']
    redirect_to '/admin/news'
    if (short != '' && full != '')
      News.create(:short => short,
                  :full => full)
      flash[:notice] = 'Notícia enviada.'
    else
      flash[:error] = 'Notícia vazia.'
    end
  end
  
  def edit
  
  end
  
  def update
    
  end
  
  def destroy
    
  end
  
end
