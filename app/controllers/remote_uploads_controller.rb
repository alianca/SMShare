# -*- coding: utf-8 -*-
class RemoteUploadsController < ApplicationController
  layout 'user_panel'

  def new
    @file = UserFile.new
  end

  def create
    render :json => {
      :id => UserFile.download(current_user, params[:user_file][:url],
                               params[:user_file][:description])
    }
  end

  def show
    job = Resque::Plugins::Status::Hash.get(params[:id])
    logger.info job.failed?
    render :json => job
  end

end
