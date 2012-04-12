require 'resque/tasks'
require 'resque_scheduler/tasks'

task 'resque:setup' => :environment

task 'resque:daily' => :environment do
  Resque.enqueue Jobs::UserStatisticsJob
end

task 'resque:files' => :environment do
  Resque.enqueue Jobs::UserFileStatisticsJob
end
