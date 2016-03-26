require './item.rb'

class GildedRose

  @items = []

  def items
    @items.each do |item|
      puts item.inspect
    end
  end

  def initialize
    @items = []
    @items << BaseItemProxy(Item.new("+5 Dexterity Vest", 10, 20))
    @items << IncreasingQualityProxy.new(Item.new("Aged Brie", 2, 0))
    @items << BaseItemProxy(Item.new("Elixir of the Mongoose", 5, 7))
    @items << LegendaryItemProxy(Item.new("Sulfuras, Hand of Ragnaros", 0, 80))
    @items << IncreasingQualityVariableProxy.new(Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20))
    @items << BaseItemProxy(Item.new("Conjured Mana Cake", 3, 6))
  end

  def update_quality
    @items.each{ |item| item.end_of_day}
  end

end