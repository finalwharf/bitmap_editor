require 'readline'
require_relative 'errors'
require_relative 'bitmap_image'

class BitmapEditor # :nodoc:
  attr_accessor :image, :command, :options

  # Supported commands and number of required options
  COMMANDS_AND_OPTION_LENGTHS = {
    '?' => 0, # ?
    'I' => 2, # I 10 20
    'C' => 0, # C
    'L' => 2, # L 2 3 C
    'V' => 4, # V 1 5 8 C
    'H' => 4, # H 5 8 1 C
    'S' => 0, # S
    'X' => 0  # X
  }.freeze

  def running=(running); @running = running; end
  def running?; @running; end

  def run
    self.running = true

    puts 'Type ? for help.'

    while running?
      input = prompt_command

      self.command = action_for_command(input)
      self.options = options_for_command(input)

      unless valid_command?
        puts "Invalid command '#{command}'"
        next
      end

      unless valid_options?
        params_count = COMMANDS_AND_OPTION_LENGTHS[command]
        puts "Command `#{command}` required #{params_count} parameters! Type `?` for help."
        next
      end

      execute_command
    end
  end

  protected

  def execute_command
    case command
    when 'I' then create_image
    when 'S' then show_image
    when 'C' then clear_image
    when '?' then show_help
    when 'X' then exit_console
    end

  rescue BitmapError => e
    puts e.message
  end

  def valid_command?
    COMMANDS_AND_OPTION_LENGTHS[command]
  end

  def valid_options?
    COMMANDS_AND_OPTION_LENGTHS[command] == options.length
  end

  def create_image
    rows = options.first.to_i
    cols = options.last.to_i
    self.image = BitmapImage.new(rows, cols)
    puts 'Image created successfully.'
  end

  def show_image
    raise MissingBitmapImageError unless image
    puts image.to_s
  end

  def clear_image
    raise MissingBitmapImageError unless image
    image.clear
  end

  def prompt_command(text = '')
    Readline.readline("#{text}> ", true).split(' ')
  end

  def action_for_command(command)
    command.first
  end

  def options_for_command(command)
    command.drop(1)
  end

  def exit_console
    puts 'Goodbye!'
    self.running = false
  end

  def show_help
    puts help_message.gsub(/^\s+/, '')
  end

  def help_message
    <<-EOF
      ?           - Show this help message
      I M N       - Create a new M x N image with all pixels coloured white (O).
      C           - Clears the table, setting all pixels to white (O).
      L X Y C     - Colours the pixel (X,Y) with colour C.
      V X Y1 Y2 C - Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive).
      H X1 X2 Y C - Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive).
      S           - Show the contents of the current image
      X           - Terminate the session
    EOF
  end
end
