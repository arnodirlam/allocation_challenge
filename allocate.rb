require_relative 'lib/scheduler'
require_relative 'lib/meeting'
require_relative 'lib/meeting_room'
require_relative 'lib/time_slot'

# Parse meetings from file meetings.txt
meetings = []
File.open('meetings.txt').each_line do |line|
  if line =~ /^(.*?) (\d+)min/
    meetings << Meeting.new($1, $2)
  end
end

meeting_rooms = [
  MeetingRoom.new("Room A", [TimeSlot.new("9:00", "12:00"), Meeting.new("Break", 60, "12:00"), TimeSlot.new("13:00", "17:00")]),
  MeetingRoom.new("Room B", [TimeSlot.new("9:00", "12:00"), Meeting.new("Break", 60, "12:00"), TimeSlot.new("13:00", "17:00")]),
]

constraints = Constraints.new.from_meetings!(meetings).from_meeting_rooms!(meeting_rooms)
scheduler = Scheduler.new(constraints)

puts "Starting at #{Time.now.strftime('%H:%M:%S')}..."
scheduler.allocations.lazy.take(1).each do |allocation|
  puts "", "" "[#{Time.now.strftime('%H:%M:%S')}] #{allocation}"

  allocation.print_example_schedule(meeting_rooms, meetings)
end
