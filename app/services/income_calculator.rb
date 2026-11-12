class IncomeCalculator
  WEEKS_PER_MONTH = 4.33

  def initialize(hourly_rate:, hours_per_day:, days_per_week:)
    @hourly_rate = hourly_rate.to_f
    @hours_per_day = hours_per_day.to_f
    @days_per_week = days_per_week.to_f
  end

  def monthly_income
    (hourly_rate * hours_per_day * days_per_week * WEEKS_PER_MONTH).round
  end

  private

  attr_reader :hourly_rate, :hours_per_day, :days_per_week
end
