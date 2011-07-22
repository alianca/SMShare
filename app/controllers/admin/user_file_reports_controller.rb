class Admin::UserFileReportsController < AdminController
  def index
    respond_with(@reports = UserFile.all.collect(&:reports).flatten)
  end
end
