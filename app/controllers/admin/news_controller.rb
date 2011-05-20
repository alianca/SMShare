class Admin::NewsController < ApplicationController
  
  before_filter :require_admin!
  before_filter :get_news_item, :only => [:show, :edit, :update, :destroy]
  uses_tiny_mce(:only => [:new, :edit],
                :options => {:theme => 'advanced',
                :theme_advanced_toolbar_location => "top",
                :theme_advanced_toolbar_align => "center",
                :theme_advanced_buttons1 => %w{formatselect fontselect fontsizeselect bold italic underline strikethrough separator justifyleft justifycenter justifyright indent outdent separator bullist numlist forecolor backcolor separator link unlink image undo redo code},
                :theme_advanced_buttons2 => [],
                :theme_advanced_buttons3 => [],
                :plugins => %w{contextmenu paste}})
  
  def index
    @news = News.all
  end
  
  def show
    
  end
  
  def new
    @item = News.new
    render :action => :edit
  end
  
  def create
    news = News.new(params['news'])
    news.date = Time.new
    if (news.save)
      flash[:notice] = 'Notícia enviada.'
      redirect_to admin_news_path(news.id)
    else
      redirect_to admin_news_index_path
    end
  end
  
  def edit
  
  end
  
  def update
    if (@item.update_attributes(params['news']))
      flash[:notice] = 'Notícia atualizada.'
      redirect_to admin_news_path(@item.id)
    else
      redirect_to admin_news_index_path
    end
  end
  
  def destroy
    @item.destroy
    flash[:notice] = 'Notícia Removida'
    redirect_to admin_news_index_path
  end
  
  private
    def get_news_item
      @item = News.find(params[:id])
    end
  
end
