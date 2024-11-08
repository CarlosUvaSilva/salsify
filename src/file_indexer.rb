# frozen_string_literal: true

require 'debug'

# FileIndexer class is responsible for indexing the lines of a file
# and providing quick access to specific lines.
class FileIndexer
  attr_reader :line_offsets, :line_count, :file_path

  # Initializes the FileIndexer with the given file path.
  # Builds the index and counts the lines in the file.
  #
  # @param file_path [String] the path to the file to be indexed
  def initialize(file_path)
    @file_path = file_path
    @line_offsets = []
    @line_count = nil

    build_index
    line_counter
  end

  private

  # Builds an index of line offsets for the file.
  # This allows quick access to specific lines by their offset.
  def build_index
    File.open(@file_path, 'r') do |file|
      offset = 0
      file.each_line do
        @line_offsets << offset
        offset = file.pos
      end
    end
  end

  # Counts the number of lines in the file.
  def line_counter
    @line_count = @line_offsets.size
  end
end
