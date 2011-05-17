class CommentsController < ApplicationController
  
  def create
    file = UserFile.find(params[:comment][:file])
    file.comments << Comment.create(:rate => params[:comment][:rate], 
                                    :message => params[:comment][:message], 
                                    :owner => current_user,
                                    :file => file)
    redirect_to :back
  end
  
  def destroy
    comment = Comment.find(params[:id])
    if comment.owner == current_user && comment.owner != nil
      comment.destroy
    end
    redirect_to :back
  end
  
end
