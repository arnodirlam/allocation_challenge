require_relative 'constraints'

# Represents a (partial) allocation of meetings to meeting room time slots
# It does not necessarily need to be feasible or complete (see `feasible?` and `complete?`, respectively)
class Allocation
  attr_reader :allocation

  def initialize(constraints, allocation)
    @constraints = constraints
    @allocation = allocation
    @allocation.each do |time_slot_hash|
      # Make sure Hash default value is 0
      time_slot_hash.default = 0
    end
  end

  # Checks whether the allocation is feasible,
  # i.e. whether any meeting room time slot is over capacity
  def feasible?
    @constraints.time_slots.each_with_index do |max_duration,i|
      sum = 0
      @allocation[i].each do |k,v|
        sum += k * v
        return false if sum > max_duration
      end
    end
    true
  end

  # Checks whether the allocation is complete,
  # i.e. whether all meetings are allocated
  def complete?
    remaining_meetings.empty?
  end

  # Returns how many meetings of each duration are not allocated
  def remaining_meetings
    remaining_meetings = @constraints.meeting_durations.dup
    @allocation.each do |time_slot_hash|
      time_slot_hash.each do |k,v|
        remaining_meetings[k] -= v
      end
    end
    remaining_meetings.reject{ |k,v| v <= 0 }
  end

  # Return all sub-nodes in the tree of possible allocations (see `README`)
  # Also see http://ruby-doc.org/core-2.4.1/Enumerator.html#method-c-new
  def sub_allocations
    if self.complete?  # it's a leaf -> return only self
      Enumerator.new do |y|
        y << self
      end
    else
      Enumerator.new do |y|
        # Iterate over all possibilities to allocate 1 more meeting.
        # These are the sub-nodes (sub-allocations) in the tree (see `README`)
        # TODO: Add order among allocations to reduce computational complexity
        remaining_meetings.keys.each do |meeting_duration|
          @allocation.length.times do |i|
            # Copy the allocation and allocate another meeting
            sub_allocation = @allocation.map(&:dup)
            sub_allocation[i][meeting_duration] += 1

            # Yield all sub-allocations of this m
            sub_allocation = Allocation.new(@constraints, sub_allocation)
            if sub_allocation.feasible?
              sub_allocation.sub_allocations.each do |sub_allocation|
                y << sub_allocation
              end
            end
          end
        end
      end
    end
  end

  # Override standard method for conversion to String (e.g. when printing)
  def to_s
    @allocation.map.with_index do |time_slot_usage, i|
      "#{time_slot_usage} (#{time_slot_usage.map{ |k,v| k*v }.sum}/#{@constraints.time_slots[i]})"
    end.join(', ')
  end

  # Override standard method to determine equality with another object
  def eql?(other)
    @allocation.eql? other.allocation
  end

  # Override standard method to hash the object for `Hash` assignment (and uniqueness)
  def hash
    @allocation.hash
  end

  # Used to print an actual example schedule with the given names of meeting
  # rooms and meetings
  def print_example_schedule(meeting_rooms, meetings)
    used_allocations = @constraints.time_slots.map{ |_| false }
    remaining_meetings = meetings.dup

    meeting_rooms.each do |meeting_room|
      puts "", meeting_room.name

      # MeetingRoom#time_slots can include `Meeting` objects (for fixed meetings)
      # and `TimeSlot` objects
      meeting_room.time_slots.each do |time_slot|
        if time_slot.is_a? Meeting
          puts time_slot
          next
        end

        # We have a `TimeSlot` object. Pick an allocation with the same duration
        # and then meetings for it to print them...
        used_allocations.each_with_index do |used,i|
          next if used
          if time_slot.duration_in_minutes == @constraints.time_slots[i]

            # found one! Now get some meetings of given durations to print them
            time_slot_meetings = []
            @allocation[i].each do |duration,count|
              count.times do
                meeting = remaining_meetings.detect{ |meeting| meeting.duration_in_minutes == duration }
                time_slot_meetings << meeting
                remaining_meetings.delete meeting
              end
            end

            # Shuffle the found meetings, calculate start times, and print them
            start_time = Time.new(2000,1,1,time_slot.starts_at.to_i,0)
            time_slot_meetings.shuffle.each do |meeting|
              puts "#{start_time.strftime("%H:%M")} #{meeting}"
              start_time += meeting.duration_in_minutes * 60
            end

            # Mark this allocation as used and carry on
            used_allocations[i] = true
            break
          end
        end
      end
    end
  end
end
