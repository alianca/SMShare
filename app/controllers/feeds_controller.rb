class FeedsController < ApplicationController
  respond_to :html, :xml

  def index
    @news = News.all.order_by :created_at, :desc
    render :layout => false
  end

  def show
    @user = User.find params[:id]
    @files = @user.files.order_by :created_at, :desc
    render :layout => false
  end
end
