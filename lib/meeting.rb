class Meeting
  attr_reader :name, :duration_in_minutes
  attr_accessor :scheduled_time

  def initialize(name, duration_in_minutes, scheduled_time=nil)
    @name = name
    @duration_in_minutes = duration_in_minutes.to_i
    @scheduled_time = scheduled_time
  end

  def to_s
    str = "#{name} (#{duration_in_minutes} min)"
    scheduled_time ? "#{scheduled_time} #{str}" : str
  end
end
