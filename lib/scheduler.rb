require_relative 'constraints'
require_relative 'allocation'

# Represents the entry point to the algorithm (see `README`).
# Initialize with a `Constraints` object and call `allocations` to get one (or multiple) feasible and complete allocations
class Scheduler
  attr_reader :constraints

  def initialize(constraints=Constraints.new)
    @constraints = constraints
  end

  # Return feasible and complete allocations
  def allocations
    root_allocation = constraints.time_slots.map do |_|
      {}
    end

    Allocation.new(constraints, root_allocation)
      .sub_allocations
  end
end
