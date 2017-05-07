require 'scheduler'

describe Scheduler do
  let(:scheduler) { Scheduler.new }

  describe "one allocation" do
    let(:allocation) { scheduler.allocations.first }

    it "is a complete and feasible allocation" do
      expect(allocation).to be_a Allocation
      expect(allocation).to be_complete
      expect(allocation).to be_feasible
    end
  end
end
