require 'allocation'

describe Allocation do
  let(:constraints) { Constraints.new }

  context "test allocation" do
    let(:allocation) do
      test_allocation = [
        {30 => 1, 45 => 2, 60 => 1},
        {30 => 1, 60 => 2},
        {30 => 3, 45 => 2, 60 => 1},
        {30 => 1, 45 => 2, 60 => 2}
      ]
      Allocation.new(constraints, test_allocation)
    end

    it "is feasible" do
      expect(allocation).to be_feasible
    end

    it "is complete" do
      expect(allocation).to be_complete
    end
  end
end
