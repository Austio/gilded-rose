require './gilded_rose.rb'
require './proxies/base_item_proxy.rb'
require "rspec"

describe GildedRose do
  # it 'Integration' do
  #   expect(described_class.new.update_quality)
  # end
end


describe BaseItemProxy do
  let(:item) { Item.new('Base', 20, 5) }
  let(:proxy) { BaseItemProxy.new(item) }
  describe '#end_of_day' do
    it 'decreases sell_in by 1' do
      expect { proxy.end_of_day }.to change { item.sell_in }.by(-1)
    end

    it 'decreases quality by 1' do
      expect { proxy.end_of_day }.to change { item.quality }.by(-1)
    end
  end

  describe 'sell by date passes' do
    let(:item) { Item.new('Base', 0, 5) }
    it 'decrements quality twice as fast' do
      expect { proxy.end_of_day }.to change { item.quality }.by(-2)
    end
  end

  describe 'quantity minimum' do
    it 'is never negative' do
      item_as_low_as_can_go = Item.new('Base', 20, 0)
      proxy = BaseItemProxy.new(item_as_low_as_can_go)

      expect { proxy.end_of_day }.to_not change { item.quality }
    end
  end

end

describe IncreasingQualityProxy do

  describe 'increments the quality' do
    describe '#end_of_day' do
      it 'increases quality by 1' do
        item = Item.new('Base', 20, 5)
        proxy = IncreasingQualityProxy.new(item)

        expect { proxy.end_of_day }.to change { item.quality }.by(1)
      end
    end
  end

  describe 'quantity maximum' do
    it 'is never more than 50' do
      item_as_high_as_can_go = Item.new('Base', 20, 50)
      proxy = IncreasingQualityProxy.new(item_as_high_as_can_go)

      expect { proxy.end_of_day }.to_not change { item_as_high_as_can_go.quality }
    end
  end

end

describe LegendaryItemProxy do
  it 'is never decreases in quality' do
    item = Item.new('Base', 20, 50)
    proxy = LegendaryItemProxy.new(item)

    expect { proxy.end_of_day }.to_not change { item.quality }
  end
end

describe IncreasingQualityVariableProxy do
  describe 'increments the quality' do
    describe '#end_of_day' do
      it 'drops to 0 on 0 sell_in days' do
        item = Item.new('Base', 0, 5)
        proxy = IncreasingQualityVariableProxy.new(item)

        expect { proxy.end_of_day }.to change { item.quality }.to(0)
      end

      it 'increases by 3 when 5 days sell_in' do
        item = Item.new('Base', 6, 6)
        proxy = IncreasingQualityVariableProxy.new(item)

        expect { proxy.end_of_day }.to change { item.quality }.by(3)
      end

      it 'increases by 2 when 10 days sell_in' do
        item = Item.new('Base', 11, 6)
        proxy = IncreasingQualityVariableProxy.new(item)

        expect { proxy.end_of_day }.to change { item.quality }.by(2)
      end

      it 'increases by 1 when more than 10 days sell_in' do
        item = Item.new('Base', 20, 6)
        proxy = IncreasingQualityVariableProxy.new(item)

        expect { proxy.end_of_day }.to change { item.quality }.by(1)
      end
    end
  end

end

describe ConjuredItemProxy do
  it 'degrates twice as fast as normal items' do
    item = Item.new('Conjured', 6, 6)
    proxy = ConjuredItemProxy.new(item)

    expect{proxy.end_of_day}.to change { item.quality }.by(-2)
  end
end