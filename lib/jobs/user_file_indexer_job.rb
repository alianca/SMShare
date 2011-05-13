class Jobs::UserFileIndexerJob
  @queue = :elasticsearch
  
  def self.perform
    UserFile.import
  end
end
