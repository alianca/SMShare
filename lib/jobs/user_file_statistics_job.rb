class Jobs::UserFileStatisticsJob
  @queue = :statistics

  def self.perform
    User.all.collect(&:files).flatten.each do |file|
      file.build_statistics
    end
  end
end
