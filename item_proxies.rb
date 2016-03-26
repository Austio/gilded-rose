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
  def maximum_quality
    50
  end

  def update_quality
    if item.quality < maximum_quality
      item.instance_eval { @quality = @quality + 1 }
    end
  end
end

class LegendaryItemProxy < BaseItemProxy
  def update_quality
  end
end

class IncreasingQualityVariableProxy < IncreasingQualityProxy
  def quality_adjusted_to_maximum(amount_to_increase_by)
    [(item.quality + amount_to_increase_by), maximum_quality].min
  end

  def update_quality
    return if item.quality == 0

    if item.sell_in <= 0
      adjusted_quality = 0
    elsif item.sell_in <= 5
      adjusted_quality = quality_adjusted_to_maximum(3)
    elsif item.sell_in <= 10
      adjusted_quality = quality_adjusted_to_maximum(2)
    else
      adjusted_quality = quality_adjusted_to_maximum(1)
    end

    item.instance_eval { @quality = adjusted_quality}
  end
end

class ConjuredItemProxy < BaseItemProxy
  def end_of_day
    update_sell_in
    2.times{ update_quality }
  end
end