class BitmapError < StandardError; end

class InvalidCommandError < BitmapError # :nodoc:
  def message
    'Invaid command! Type `?` for help.'
  end
end

class MissingBitmapImageError < BitmapError # :nodoc:
  def message
    'No image to work with!'
  end
end

class InvalidBitmapSizeError < BitmapError # :nodoc:
  def message
    min = BitmapImage::MIN_SIZE
    max = BitmapImage::MAX_SIZE
    "Invalid size! Width and height must be between #{min} and #{max}."
  end
end

class InvalidBitmapCoordinatesError < BitmapError # :nodoc:
  def message
    'Invalid coordinates! X and/or Y are out of bounds.'
  end
end
