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
    if item.quality > 0
      quality_to_subtract = (item.sell_in < 0) ? 2 : 1

      item.instance_eval { @quality = @quality - quality_to_subtract }
    end
  end
end

class IncreasingQualityProxy < BaseItemProxy
  def update_quality
    if item.quality < 50
      item.instance_eval { @quality = @quality + 1 }
    end
  end
end

class LegendaryItemProxy < BaseItemProxy
  def update_quality
  end
end

class IncreasingQualityVariableProxy < BaseItemProxy
  def update_quality
    return if item.quality == 0

    if item.sell_in <= 0
      item.instance_eval { @quality = 0 }
    elsif item.sell_in <= 5
      item.instance_eval { @quality = @quality + 3 }
    elsif item.sell_in <= 10
      item.instance_eval { @quality = @quality + 2 }
    else
      item.instance_eval { @quality = @quality + 1 }
    end
  end
end

class ConjuredItemProxy < BaseItemProxy
  def end_of_day
    update_sell_in
    2.times{ update_quality }
  end
end