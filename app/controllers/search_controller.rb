class SearchController < ApplicationController
  before_filter :only => [:index, :show]

  def index
    @files = UserFile.search(params[:q], :per_page => 10,
                             :page => params[:page] || 1) if params[:q]

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
