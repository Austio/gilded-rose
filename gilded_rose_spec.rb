require './gilded_rose.rb'
require './proxies/base_item_proxy.rb'
require "rspec"

describe GildedRose do
  # it 'Integration' do
  #   expect(described_class.new.update_quality)
  # end

  let(:item) { Item.new('Base', 20, 5)}

  describe BaseItemProxy do
    let(:proxy) { BaseItemProxy.new(item) }
    describe '#end_of_day' do
      it 'decreases sell_in by 1' do
        expect{proxy.end_of_day}.to change{item.sell_in}.by(-1)
      end

      it 'decreases quality by 1' do
        expect{proxy.end_of_day}.to change{item.quality}.by(-1)
      end
    end

    describe 'sell by date passes' do
      let(:item) { Item.new('Base', 0, 5)}
      it 'decrements quality twice as fast' do
        expect{proxy.end_of_day}.to change{item.quality}.by(-2)
      end
    end

    describe 'quantity minimum' do
      it 'is never negative' do
        proxy = BaseItemProxy.new(Item.new('Base', 20, 0))

        expect{proxy.end_of_day}.to_not change{item.quality}
      end
    end
  end

  describe IncreasingQualityProxy do
    describe 'increments the quality' do
      describe '#end_of_day' do
        it 'increases quality by 1' do
          proxy = IncreasingQualityProxy.new(Item.new('Base', 20, 0))
          
          expect{proxy.end_of_day}.to change{item.quality}.by(1)
        end
      end
    end
  end
end
