require_relative 'errors'

class BitmapImage # :nodoc:
  attr_accessor :rows, :cols, :pixels

  DEFAULT_COLOUR = 'O'.freeze
  VALID_DIMENSIONS = 1...250

  def initialize(rows, cols)
    self.rows = rows
    self.cols = cols

    raise InvalidBitmapBoundsError unless valid_dimensions?

    self.pixels = Array.new(rows) { Array.new(cols, DEFAULT_COLOUR) }
  end

  def valid_dimensions?
    VALID_DIMENSIONS.include?(rows) && VALID_DIMENSIONS.include?(cols)
  end

  def clear
    raise MissingBitmapImageError unless pixels
    pixels.each { |row| row.fill(DEFAULT_COLOUR) }
  end

  def to_s
    pixels.map(&:join).join("\n")
  end
end
