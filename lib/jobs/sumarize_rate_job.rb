class Jobs::SumarizeRateJob
  @queue = :rates

  def self.perform
    UserFile.all.each do |file|
      file.summarize_rate!
    end
  end
end
