class Jobs::SumarizeRateJob
  @queue = :rates
  
  def self.perform
    UserFile.all.each do |file|
      sum = 0.0
      count = 0
      
      file.comments.all.each do |comment|
        if comment.rate > 0
          sum += comment.rate
          count += 1
        end
      end
      
      if count > 0
        file.rate = sum * 1.0 / count
      else
        file.rate = 0.0
      end
            
      file.save!
    end
  end
end
