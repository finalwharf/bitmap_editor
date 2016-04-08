require 'rspec'
require 'spec_helper'
require 'bitmap_image'

describe BitmapImage do
  context '#initialize' do
    context 'with valid dimensions' do
      subject { described_class.new(3, 3) }

      let(:pixels) { [%w(O O O), %w(O O O), %w(O O O)] }

      it 'creates a bitmap image' do
        expect(subject).to be_a(BitmapImage)
      end

      it 'creates an image with correct width' do
        expect(subject.pixels.length).to eq 3
      end

      it 'creates an image with correct height' do
        expect(subject.pixels[0].length).to eq 3
      end

      it 'creates a white image' do
        expect(subject.pixels).to eq pixels
      end
    end

    context 'with invalid dimensions' do
      it 'raises an error' do
        danger = proc { described_class.new(1, 251) }
        expect { danger.call }.to raise_error(InvalidBitmapSizeError)
      end
    end
  end

  context '#to_s' do
    subject { described_class.new(3, 3) }
    let(:expected_outout) { "OOO\nOOO\nOOO" }

    it 'displays image' do
      expect(subject.to_s).to eq expected_outout
    end
  end

  context '#clear' do
    it 'clears the image' do
      image = BitmapImage.new(3, 3)
      image.pixels[1] = ['X', 'X', 'X']
      image.clear
      expect(image.pixels[1]).to eq ['O', 'O', 'O']
    end
  end

  context '#color_pixel' do
    it 'colors a pixel with the specified color' do
      image = BitmapImage.new(3, 3)
      image.color_pixel(1, 1, 'Z')
      expect(image.pixels[0][0]).to eq 'Z'
    end
  end

  context '#color_row' do
    it 'colors a row Y from X1 to X2 with the specified color' do
      image = BitmapImage.new(3, 3)
      image.color_row(2, 1, 3, 'Z')
      expect(image.to_s).to eq "OOO\nZZZ\nOOO"
    end
  end

  context '#color_column' do
    it 'colors a column X from Y1 to Y2 with the specified color' do
      image = BitmapImage.new(3, 3)
      image.color_column(2, 1, 3, 'Z')
      expect(image.to_s).to eq "OZO\nOZO\nOZO"
    end
  end
end
