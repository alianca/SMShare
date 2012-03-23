module SMShare
  module GridIO

    def size
      (file_length / chunk_size) + (file_length % chunk_size > 0 ? 1 : 0)
    end

    def each
      size.times { yield read(chunk_size) }
    end

  end
end
