class StreetSweepingScheduleParserError < StandardError
end

class StreetSweepingSchedule
  TWO_DAYS_REGEX = /^(\d)(st|nd|rd|th) and (\d)(st|nd|rd|th) (Sun|Mon|Tues|Wed|Thurs|Fri|Sat)$/
  EVERY_REGEX = /^Every (Mon|Wed|Fri), (Mon|Wed|Fri), (Mon|Wed|Fri)$/

  def initialize(schedule)
    if schedule == 'No Sweeping (Uncontrol Condition)'
      @no_sweeping = true
    elsif matches = schedule.match(TWO_DAYS_REGEX)
      @days_of_month = matches.values_at(1, 3).collect(&:to_i)
      @days_of_week = matches.values_at(5)
    elsif matches = schedule.match(EVERY_REGEX)
      @days_of_week = matches.to_a
    else
      raise StreetSweepingDayParserError, schedule
    end
  end

  def sweeping_on?(date)
    return false if @no_sweeping

    if @days_of_month
      day_of_week?(date) && @days_of_month.include?(nth_wday_of_month(date))
    else
      day_of_week?(date)
    end
  end

  private

  def day_of_week?(date)
    @days_of_week.any? do |wday|
      date.wday == Date::ABBR_DAYNAMES.index(wday)
    end
  end

  def nth_wday_of_month(date)
    first_day = date.beginning_of_month
    last_day = first_day.end_of_month

    matching_wdays = (first_day..last_day).to_a.select do |day|
      day.wday == date.wday
    end

    nth_index = matching_wdays.find_index do |day|
      day == date
    end

    nth_index + 1
  end
end
