class TimeSlot
  attr_reader :starts_at, :ends_at

  def initialize(starts_at, ends_at)
    @starts_at = starts_at
    @ends_at = ends_at
  end

  def duration_in_minutes
    (parse_time_str(ends_at) - parse_time_str(starts_at)) / 60
  end


  private

  def parse_time_str(time_str)
    if time_str =~ /^(\d+):(\d\d)$/
      Time.new(2017,1,1,$1.to_i,$2.to_i)
    else
      raise StandardError, "Invalid time format: #{time_str.inspect}"
    end
  end
end
