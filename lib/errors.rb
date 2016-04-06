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

class InvalidBitmapBoundsError < BitmapError # :nodoc:
  def message
    min = BitmapImage::VALID_DIMENSIONS.first
    max = BitmapImage::VALID_DIMENSIONS.last
    "Invalid bounds! Must be between #{min} and #{max}."
  end
end
