require 'scheduler'
require 'set'

# Represents allocation constraints, i.e. time slots and meetings
class Constraints
  attr_reader :time_slots, :meetings

  def initialize
    @time_slots = [3*60, 3*60, 4*60, 4*60]

    @meetings = {
      30 => 6,
      45 => 6,
      60 => 6,
    }
  end
end