class BaseItemProxy
  attr_accessor :item

  def initialize(item)
    @item = item
  end

  def end_of_day
    update_sell_in
    update_quality
  end

  private

  def update_sell_in
    item.instance_eval { @sell_in = @sell_in - 1 }
  end

  def update_quality
    return if item.quality == 0

    if item.sell_in < 0
      item.instance_eval { @quality = @quality - 2 }
    else
      item.instance_eval { @quality = @quality - 1 }
    end
  end
end

class IncreasingQualityProxy < BaseItemProxy
  def update_quality
    item.instance_eval { @quality = @quality + 1 }
  end
end