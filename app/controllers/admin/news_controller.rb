# -*- coding: utf-8 -*-
class Admin::NewsController < AdminController
  before_filter :get_news_item, :only => [:show, :edit, :update, :destroy]

  def index
    @news = News.all
  end

  def new
    @item = News.new
    render :edit
  end

  def create
    news = News.new(params['news'])
    if (news.save)
      flash[:notice] = 'Notícia enviada.'
    else
      flash[:alert] = 'Notícia não foi enviada.'
    end
    redirect_to admin_news_index_path
  end

  def update
    if (@item.update_attributes(params['news']))
      flash[:notice] = 'Notícia atualizada.'
    else
      flash[:alert] = 'Notícia não foi atualizada.'
    end
    redirect_to admin_news_index_path
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
