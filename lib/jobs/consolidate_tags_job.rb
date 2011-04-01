module Jobs
  class ConsolidateTagsJob
    @queue = :tags
    
    def self.perform
      Tag.consolidate!
    end
  end
end
