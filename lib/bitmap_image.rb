require_relative 'errors'

class BitmapImage # :nodoc:
  attr_accessor :rows, :cols, :pixels

  DEFAULT_COLOUR = 'O'.freeze
  VALID_DIMENSIONS = 1...250

  def initialize(rows, cols)
    self.rows = rows
    self.cols = cols

    raise InvalidBitmapBoundsError unless valid_dimensions?

    self.pixels = Array.new(rows) do
      Array.new(cols, DEFAULT_COLOUR)
    end
  end

  def valid_dimensions?
    VALID_DIMENSIONS.include?(rows) && VALID_DIMENSIONS.include?(cols)
  end

  def to_s
    pixels.map(&:join).join("\n")
  end
end
