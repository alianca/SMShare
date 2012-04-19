require 'resque/tasks'
require 'resque_scheduler/tasks'

task 'resque:setup' => :environment

task 'resque:daily' => :environment do
  User.all.each do |user|
    Resque.enqueue Jobs::UserStatisticsJob, user._id
  end
end
