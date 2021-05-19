class GildedRose
  attr_reader :name, :days_remaining, :quality

  def initialize(name:, days_remaining:, quality:)
    @name = name
    @days_remaining = days_remaining
    @quality = quality
  end

  def tick
    return if legendary_item?

    initial_quality_adjustment = if better_with_age?
      1 + scarcity_adjustment
    else
      -1
    end

    adjust_quality_by(initial_quality_adjustment)

    @days_remaining = @days_remaining - 1

    handle_expiration if expired_item?
  end

  private

  def adjust_quality_by(amount)
    return @quality if max_quality?
    return 0 if @quality.zero?

    amount = amount * 2 if conjured_item?

    @quality = @quality + amount
  end

  def better_with_age?
    tickets? || brie?
  end

  def brie?
    @name == "Aged Brie"
  end

  def conjured_item?
    @name =~ /Conjured/i
  end

  def expirable_item?
    !(legendary_item? || brie?)
  end

  def expired_item?
    @days_remaining < 0
  end

  def handle_expiration
    if brie?
      adjust_quality_by(1)
    elsif tickets?
      adjust_quality_by(-@quality)
    else
      adjust_quality_by(-1)
    end
  end

  def legendary_item?
    @name == "Sulfuras, Hand of Ragnaros"
  end

  def max_quality?
    @quality >= 50
  end

  def scarcity_adjustment
    return 0 unless tickets?

    case @days_remaining
    when (1..5)  then 2
    when (6..10) then 1
    else
      0
    end
  end

  def tickets?
    @name == "Backstage passes to a TAFKAL80ETC concert"
  end
end
