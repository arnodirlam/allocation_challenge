require 'constraints'

# Represents a (partial) allocation of meetings to meeting room time slots
# It does not necessarily need to be feasible or complete (see `feasible?` and `complete?`, respectively)
class Allocation
  def initialize(constraints, allocation)
    @constraints = constraints
    @allocation = allocation  # Array of Hashes
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
    remaining_meetings = @constraints.meetings.dup
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
    Enumerator.new do |y|

    end
  end
end
