class Admin::CommentsController < AdminController
  def index
    respond_with(@comments = UserFile.all.collect(&:comments).flatten)
  end
  
  def block
    @comment = UserFile.where("comments._id" => BSON::ObjectId(params[:id])).first.comments.find(params[:id])
    @comment.blocked = true; @comment.save!
    respond_with(@comment, :location => admin_comments_path)    
  end
  
  def unblock
    @comment = UserFile.where("comments._id" => BSON::ObjectId(params[:id])).first.comments.find(params[:id])
    @comment.blocked = false; @comment.save!
    respond_with(@comment, :location => admin_comments_path)    
  end
end
