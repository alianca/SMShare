class Jobs::UserFileStatisticsJob
  @queue = :statistics

  def self.perform
    User.all.collect(&:files).flatten.each do |file|
      file.statistics.generate_statistics!
    end
  end
end
