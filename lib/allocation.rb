# Represents a (partial) allocation of meetings to meeting room time slots
# It does not necessarily need to be feasible or complete (see `feasible?` and `complete?`, respectively)
class Allocation
  def initialize(constraints, allocation)
    @constraints = constraints
    @allocation = allocation
  end

  # Checks whether the allocation is feasible,
  # i.e. whether any meeting room time slot is over capacity
  def feasible?
    nil
  end

  # Checks whether the allocation is complete,
  # i.e. whether all meetings are allocated
  def complete?
    nil
  end

  # Return all sub-nodes in the tree of possible allocations (see `README`)
  # Also see http://ruby-doc.org/core-2.4.1/Enumerator.html#method-c-new
  def sub_allocations
    Enumerator.new do |y|

    end
  end
end
