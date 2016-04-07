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

  describe 'Image creation' do
    context 'with valid parameters' do
      it 'creates a new image' do
        send_command('I 3 3') do
          expect(STDOUT).to receive(:puts).with 'Image created successfully.'
          expect(subject).to receive(:create_image).and_call_original
          expect(subject).to receive(:image=).and_call_original
        end
      end
    end

    context 'with invalid parameters' do
      it 'prints an error message' do
        send_command('I') do
          message = 'Command `I` required 2 parameters! Type `?` for help.'
          expect(STDOUT).to receive(:puts).with message
          expect(subject).to_not receive(:create_image)
        end
      end
    end
  end

  describe 'Displaying image' do
    context 'when present' do
      it 'show the image ' do
        send_command('S') do
          image = BitmapImage.new(3, 3)
          allow(subject).to receive(:image).and_return(image)
          expect(subject).to receive(:show_image).and_call_original
          expect(STDOUT).to receive(:puts).with("OOO\nOOO\nOOO")
        end
      end
    end

    context 'when not present' do
      it 'shows an error message' do
        send_command('S') do
          expect(subject).to receive(:show_image).and_call_original
          expect(STDOUT).to receive(:puts).with('No image to work with!')
        end
      end
    end
  end

  describe 'Clearing image' do
    context 'when present' do
      it 'clears the image' do
        send_command('C') do
          image = BitmapImage.new(3, 3)
          allow(subject).to receive(:image).and_return(image)
          expect(subject).to receive(:clear_image).and_call_original
          expect(subject.image).to receive(:clear)
        end
      end
    end

    context 'when not present' do
      it 'shows an error message' do
        send_command('C') do
          expect(subject).to receive(:clear_image).and_call_original
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
          error_message = 'Command `X` required 0 parameters! Type `?` for help.'
          expect(STDOUT).to receive(:puts).with(error_message)
        end
      end
    end
  end
end
