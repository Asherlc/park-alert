class StreetSweepingDayParserError < StandardError end

class StreetSweepingDay
  TWO_DAYS_REGEX = /^(\d)(st|nd|rd|th) and (\d)(st|nd|rd|th) (Sun|Mon|Tues|Wed|Thurs|Fri|Sat)$/
  EVERY_REGEX = /^Every (Mon|Wed|Fri), (Mon|Wed|Fri), (Mon|Wed|Fri)$/

  def initialize(date)
    if matches = date.match(TWO_DAYS_REGEX)
      @days_of_week = matches.values_at(0, 4)
      @day_of_month = matches[6]
    if matches = date.match(EVERY_REGEX)
      @days_of_week = matches.to_a
    else
      raise StreetSweepingDayParserError.new(date)
    end
  end

  def is_day_of_week?
    @days_of_week.any? do |wday|
      today.wday == Date::ABBR_DAYNAMES.index(wday)
    end
  end

  def todays_nth_of_month
    today = Date.today
    first_day = today.beginning_of_month
    last_day = first_day.end_of_month

    week_index = (first_day..last_day).to_a.select do |day|
      day.wday == today.wday
    end.find_index do |day|
      day == today
    end
  end

  def today?
    today = Date.today

    if @days_of_weekd
      is_day_of_week? && @days_of_week.include?(todays_nth_of_month)
    else
      is_day_of_week?
    end
  end
end
