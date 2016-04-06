require 'rspec'
require 'spec_helper'
require 'bitmap_editor'
require 'bitmap_image'

describe BitmapEditor do
  describe 'Image creation' do
    context 'with valid parameters' do
      let(:expected_image) { [%w(O O O), %w(O O O), %w(O O O)] }

      it 'creates a new image and exits' do
        allow(Readline).to receive(:readline).and_return('I 3 3', 'X')
        expect(subject).to receive(:puts).with('Type ? for help.')
        expect(subject).to receive(:puts).with('Image created successfully.')
        expect(subject).to receive(:puts).with('Goodbye!')
        subject.run
        expect(subject.image.pixels).to eq expected_image
      end
    end

    context 'with invalid parameters' do
      it 'prints error message and exits' do
        allow(Readline).to receive(:readline).and_return('I', 'X')
        expect(subject).to receive(:puts).with('Type ? for help.')
        expect(subject).to receive(:puts).with('Command `I` required 2 parameters! Type `?` for help.')
        expect(subject).to receive(:puts).with('Goodbye!')
        subject.run
        expect(subject.image).to be_nil
      end
    end
  end

  describe 'Displaying image' do
    context 'when present' do
      let(:expected_image) { [%w(O O O), %w(O O O), %w(O O O)] }
      it 'show a 3x3 image ' do
        allow(Readline).to receive(:readline).and_return('I 3 3', 'S', 'X')
        expect(subject).to receive(:puts).with('Type ? for help.')
        expect(subject).to receive(:puts).with('Image created successfully.')
        expect(subject).to receive(:puts).with("OOO\nOOO\nOOO")
        expect(subject).to receive(:puts).with('Goodbye!')
        subject.run
      end
    end

    context 'when not present' do
      it 'shows an error message' do
        allow(Readline).to receive(:readline).and_return('S', 'X')
        expect(subject).to receive(:puts).with('Type ? for help.')
        expect(subject).to receive(:puts).with('No image to work with!')
        expect(subject).to receive(:puts).with('Goodbye!')
        subject.run
      end
    end
  end
end
