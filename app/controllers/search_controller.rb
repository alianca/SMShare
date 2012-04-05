class SearchController < ApplicationController
  before_filter :only => [:index, :show]

  def index
    @files = UserFile.find_filter_and_order(params[:q], params[:filter], params[:order]).
      paginate(:per_page => 10, :page => params[:page])

    respond_to do |f|
      f.html {}
      f.json { render :json => [params[:q], @files.collect(&:alias).uniq],
        :content_type => "application/x-suggestions+json" }
    end
  end

  def opensearch
    respond_to do |f|
      f.html {}
      f.xml { render :layout => false,
        :content_type => "application/opensearchdescription+xml" }
    end
  end
end
