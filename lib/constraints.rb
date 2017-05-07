require_relative 'scheduler'

# Represents allocation constraints, i.e. time slots and meetings
# Initialization:
#   - time_slots - Array of durations (in minutes) of each time slot (e.g. [3*60, 3*60, 4*60, 4*60])
#   - meeting_durations - Hash counting how many meetings have which duration (in minutes; e.g {30 => 6, 45 => 6, 60 => 6})
#
class Constraints
  attr_reader :time_slots, :meeting_durations

  def initialize(time_slots=nil, meeting_durations=nil)
    @time_slots = time_slots
    @meeting_durations = meeting_durations
  end

  # Translate algorithmic constraints from Array of `Meeting` objects.
  # Returns self.
  def from_meetings!(meetings)
    @meeting_durations = Hash.new(0)
    meetings.each do |meeting|
      @meeting_durations[meeting.duration_in_minutes] += 1
    end
    self
  end

  # Translate algorithmic constraints from Array of `MeetingRoom` objects.
  # Returns self.
  def from_meeting_rooms!(meeting_rooms)
    @time_slots = []
    meeting_rooms.each do |meeting_room|
      meeting_room.time_slots.each do |time_slot|
        if time_slot.is_a? TimeSlot
          @time_slots << time_slot.duration_in_minutes
        end
      end
    end
    self
  end
end
