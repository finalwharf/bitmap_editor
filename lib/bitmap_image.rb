require_relative 'errors'

class BitmapImage # :nodoc:
  attr_accessor :rows, :cols, :pixels
  DEFAULT_COLOUR = 'O'.freeze
  MIN_SIZE = 1
  MAX_SIZE = 250

  def initialize(rows, cols)
    raise InvalidBitmapSizeError unless valid_size?(rows, cols)

    self.rows = rows
    self.cols = cols

    self.pixels = Array.new(rows) { Array.new(cols, DEFAULT_COLOUR) }
  end

  def valid_size?(rows, cols)
    rows.between?(MIN_SIZE, MAX_SIZE) && cols.between?(MIN_SIZE, MAX_SIZE)
  end

  def valid_coordinates?(row, col)
    row.between?(MIN_SIZE, rows) && col.between?(MIN_SIZE, cols)
  end

  def clear
    pixels.each { |row| row.fill(DEFAULT_COLOUR) }
  end

  def color_pixel(row, col, color)
    raise InvalidBitmapCoordinatesError unless valid_coordinates?(row, col)
    pixels[row - 1][col - 1] = color
  end

  def color_row(row, x1, x2, color)
    unless valid_coordinates?(row, x1) && valid_coordinates?(row, x2)
      raise InvalidBitmapCoordinatesError
    end

    range = (x1 - 1)..(x2 - 1)
    pixels[row - 1].fill(color, range)
  end

  def color_column(col, y1, y2, color)
    unless valid_coordinates?(y1, col) && valid_coordinates?(y2, col)
      raise InvalidBitmapCoordinatesError
    end

    col_idx = col - 1
    pixels.each_with_index do |row, idx|
      row[col_idx] = color if idx.between?(y1 - 1, y2 - 1)
    end
  end

  def to_s
    pixels.map(&:join).join("\n")
  end
end
