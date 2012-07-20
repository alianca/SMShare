class Admin::CommentsController < AdminController

  def index
    if params[:q].blank?
      @comments = UserFile.all.collect(&:comments).flatten
    else
      @comments = Comment.search(params[:q])
    end

    respond_with(@comments)
  end

  def block
    @comment = UserFile.find(params[:file_id]).comments.find(params[:id])
    @comment.blocked = true
    @comment.save!
    respond_with(@comment, :location => admin_comments_path)
  end

  def unblock
    @comment = UserFile.find(params[:file_id]).comments.find(params[:id])
    @comment.blocked = false
    @comment.save!
    respond_with(@comment, :location => admin_comments_path)
  end

end
