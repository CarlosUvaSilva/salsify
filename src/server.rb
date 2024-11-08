require 'webrick'
require_relative './file_indexer'

# LineServer class is responsible for serving lines of a file
# over HTTP using the WEBrick server.
class LineServer
  def initialize(file_indexer)
    @file_indexer = file_indexer
  end

  # Starts the WEBrick HTTP server on port 8080.
  # Configures an endpoint to retrieve a specific line.
  def start
    server = WEBrick::HTTPServer.new(Port: 8080)

    server.mount_proc '/lines' do |req, res|
      line_index = req.path.split('/').last.to_i
      # Line index is 0-based but the API is 1-based
      line_index -= 1
      if line_index.negative? || line_index >= @file_indexer.line_count
        res.status = 413
        res.body = 'Requested line out of bounds'
      else
        res.status = 200
        res.body = get_line(line_index)
      end
    end

    trap('INT') { server.shutdown }
    server.start
  end

  private

  # Retrieves the line at the specified index from the file.
  #
  # @param index [Integer] the 0-based index of the line to retrieve
  # @return [String] the content of the line
  def get_line(index)
    File.open(@file_indexer.file_path, 'r') do |file|
      file.seek(@file_indexer.line_offsets[index])
      file.readline
    end
  end
end

# Usage example:
file_path = 'files/text_file.txt'
file_indexer = FileIndexer.new(file_path)
server = LineServer.new(file_indexer)
server.start
