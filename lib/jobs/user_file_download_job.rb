class Jobs::UserFileDownloadJob
  include Resque::Plugins::Status

  @queue = :downloads
  STATUS_URL = "localhost:4242/files/status/"

  def perform
    puts "Starting loop"
    while true
      puts "In loop"

      begin
        result = Curl::Easy.perform(STATUS_URL + options['id'])
        status = JSON.parse(result.body_str)['ok']
        puts "[RESULT] %s" % [result.body_str]
      rescue
        failed('error' => "request_failed")
        puts "[ERROR] Request Failed"
        return
      end

      if status['ok']
        begin
          user = User.find(BSON::ObjectId(options['user_id']))
        rescue
          failed('error' => "user_not_found")
          puts "[ERROR] User Not Found"
          return
        end

        file = user.files.create(status['ok'])
        if file.save
          completed('file_id' => file._id)
          puts "[DONE] %s" % [file._id]
          return
        else
          failed('error' => "file_creation")
          puts "[ERROR] Invalid File"
          return
        end
      elsif status['progress']
        puts status['progress'].to_json
        current = status['progress']['at']
        total = status['progress']['total']
        at(current, total, 'progress' => "%s%%" % [100.0 * current / total])
      elsif status['error']
        failed('error' => status['error'])
        puts "[ERROR] %s" % [status['error'].to_json]
        return
      end

      sleep 0.5
    end

  end

end
