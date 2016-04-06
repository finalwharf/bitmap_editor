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
        danger = proc { described_class.new(0, 256) }
        expect { danger.call }.to raise_error(InvalidBitmapBoundsError)
      end
    end
  end

  context '#to_s' do
    subject { described_class.new(3, 3) }
    let(:outout) { "OOO\nOOO\nOOO" }

    it 'displays image' do
      expect(subject.to_s).to eq outout
    end
  end
end
