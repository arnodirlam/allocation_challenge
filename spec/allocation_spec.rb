require 'allocation'

describe Allocation do
  let(:constraints) { Constraints.new }

  context "empty allocation" do
    let(:allocation) do
      Allocation.new(constraints, [{}, {}, {}, {}])
    end

    it "is feasible" do
      expect(allocation).to be_feasible
    end

    it "is not complete" do
      expect(allocation).not_to be_complete
    end
  end

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

  context "overbooked allocation" do
    let(:allocation) do
      test_allocation = [
        {30 => 1, 45 => 2, 60 => 1},
        {30 => 1, 60 => 4},
        {30 => 3, 45 => 2, 60 => 1},
        {30 => 1, 45 => 2}
      ]
      Allocation.new(constraints, test_allocation)
    end

    it "is not feasible" do
      expect(allocation).not_to be_feasible
    end

    it "is complete" do
      expect(allocation).to be_complete
    end
  end
end
