require 'scheduler'

describe Scheduler do
  let(:constraints) do
    Constraints.new [60, 90], {30 => 1, 45 => 1, 60 => 1}
  end
  let(:scheduler) { Scheduler.new(constraints) }

  describe "allocations" do
    it "are complete" do
      expect(scheduler.allocations).to all be_complete
    end
  end

  describe "feasible allocations" do
    let(:allocations) do
      scheduler.allocations.select(&:feasible?)
    end

    it "returns 2 unique allocations" do
      expect(allocations.uniq.length).to eq 2
    end

    xit "returns only unique allocations" do
      expect(allocations.length).to eq allocations.uniq.length
    end
  end
end
