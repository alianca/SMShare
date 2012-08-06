class CommentsController < ApplicationController

  before_filter :authenticate_user!

  def create
    file = UserFile.Zfind(params[:comment][:file])
    if file.owner != current_user
      file.comments.create(:rate => params[:comment][:rate],
                           :message => params[:comment][:message],
                           :owner => current_user,
                           :file => file)
      file.needs_statistics!
    end

    redirect_to :back
  end

  def destroy
    file = UserFile.find(params[:file_id])
    comment = file.comments.find(params[:id])
    if comment.owner == current_user
      comment.destroy
      file.needs_statistics!
    end

    redirect_to :back
  end

end
