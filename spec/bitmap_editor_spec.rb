require 'rspec'
require 'spec_helper'
require 'bitmap_editor'
require 'bitmap_image'

describe BitmapEditor do
  def send_command(command, &block)
    allow(Readline).to receive(:readline).and_return(command)
    allow(subject).to receive(:running?).and_return(true, false)
    expect(STDOUT).to receive(:puts).with 'Type ? for help.'

    yield if block_given?

    subject.run
  end

  def prepare_image
    image = BitmapImage.new(3, 3)
    allow(subject).to receive(:image).and_return(image)
  end

  describe 'Image creation' do
    context 'with valid parameters' do
      it 'creates a new image' do
        send_command('I 3 3') do
          expect(subject).to receive(:create_image).and_call_original
          expect(STDOUT).to receive(:puts).with 'Image created successfully.'
          expect(BitmapImage).to receive(:new).with(3, 3)
          expect(subject).to receive(:image=)
        end
      end
    end

    context 'with invalid parameters' do
      it 'prints an error message' do
        send_command('I') do
          message = 'Command requires 2 parameters! Type `?` for help.'
          expect(STDOUT).to receive(:puts).with message
          expect(subject).to_not receive(:create_image)
        end
      end
    end
  end

  describe 'Displaying image' do
    context 'when present' do
      it 'show the image ' do
        image = BitmapImage.new(3, 3)
        allow(subject).to receive(:image).and_return(image)

        send_command('S') do
          expect(subject).to receive(:show_image).and_call_original
          expect(STDOUT).to receive(:puts).with("OOO\nOOO\nOOO")
        end
      end
    end

    context 'when not present' do
      it 'shows an error message' do
        send_command('S') do
          expect(subject).to_not receive(:show_image)
          expect(STDOUT).to receive(:puts).with('No image to work with!')
        end
      end
    end
  end

  describe 'Clearing image' do
    context 'when present' do
      it 'clears the image' do
        prepare_image

        send_command('C') do
          expect(subject).to receive(:clear_image).and_call_original
          expect(subject.image).to receive(:clear)
        end
      end
    end

    context 'when not present' do
      it 'shows an error message' do
        send_command('C') do
          expect(subject).to_not receive(:clear_image)
          expect(STDOUT).to receive(:puts).with('No image to work with!')
        end
      end
    end
  end

  describe 'Exiting the editor' do
    context 'when command is correct' do
      it 'exits the application ' do
        send_command('X') do
          expect(subject).to receive(:exit_console).and_call_original
          expect(STDOUT).to receive(:puts).with('Goodbye!')
        end
      end
    end

    context 'when command is incorrect' do
      it 'prints error message' do
        send_command('X X') do
          expect(subject).to_not receive(:exit_console)
          error_message = 'Command requires no parameters! Type `?` for help.'
          expect(STDOUT).to receive(:puts).with(error_message)
        end
      end
    end
  end

  describe 'Coloring pixels' do
    context 'when image is present' do
      it 'colors a pixel with the specified color' do
        prepare_image

        send_command('L 1 1 X') do
          expect(subject).to receive(:color_pixel).and_call_original
          expect(subject.image).to receive(:color_pixel).with(1, 1, 'X')
        end
      end

      it 'shows an error message when command is incomplete' do
        send_command('L 1 1') do
          expect(subject).to_not receive(:color_pixel)
          error_message = 'Command requires 3 parameters! Type `?` for help.'
          expect(STDOUT).to receive(:puts).with(error_message)
        end
      end
    end

    context 'when image is not present' do
      it 'shows an error message' do
        send_command('L 1 1 X') do
          expect(subject).to_not receive(:color_pixel)
          expect(STDOUT).to receive(:puts).with('No image to work with!')
        end
      end
    end
  end

  describe 'Coloring a horizontal segment' do
    context 'when image is present' do
      it 'colors row Y from X1 to X2' do
        prepare_image

        send_command('H 2 1 3 X') do
          expect(subject).to receive(:color_horizontal_segment).and_call_original
          expect(subject.image).to receive(:color_row).with(2, 1, 3, 'X')
        end
      end
    end

    context 'when image is not present' do
      it 'shows an error message' do
        send_command('H 2 1 3 X') do
          expect(subject).to_not receive(:color_horizontal_segment)
          expect(STDOUT).to receive(:puts).with('No image to work with!')
        end
      end
    end
  end

  describe 'Coloring a vertical segment' do
    context 'when image is present' do
      it 'colors column X from Y1 to Y2' do
        prepare_image

        send_command('V 2 1 3 X') do
          expect(subject).to receive(:color_vertical_segment).and_call_original
          expect(subject.image).to receive(:color_column).with(2, 1, 3, 'X')
        end
      end
    end

    context 'when image is not present' do
      it 'shows an error message' do
        send_command('V 2 1 3 X') do
          expect(subject).to_not receive(:color_vertical_segment)
          expect(STDOUT).to receive(:puts).with('No image to work with!')
        end
      end
    end
  end
end
