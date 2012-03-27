class FeedsController < ApplicationController
  respond_to :xml

  after_filter :append_xml_type

  def index
    @news = News.all
    render :layout => false
  end

  def show
    @user = User.find params[:id]
    @files = @user.files.to_a.sort { |a, b| b.created_at <=> a.created_at }
    render :layout => false
  end

  private

  def append_xml_type
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end
end
