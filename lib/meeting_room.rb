class MeetingRoom
  attr_reader :name, :time_slots

  def initialize(name, time_slots)
    @name = name
    @time_slots = time_slots
  end
end
