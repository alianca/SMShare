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
    resumida = params['noticia']['resumida']
    completa = params['noticia']['completa']
    redirect_to '/admin/news'
    if (resumida != '' && completa != '')
      Noticia.create(:resumida => params['noticia']['resumida'],
                     :completa => params['noticia']['completa'])
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
