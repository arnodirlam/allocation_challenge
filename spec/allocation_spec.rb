require 'allocation'

describe Allocation do
  let(:constraints) { Constraints.new([3*60, 3*60, 4*60, 4*60], {30 => 6, 45 => 6, 60 => 6}) }
  let(:allocation) do
    Allocation.new(constraints, [{}, {}, {}, {}])
  end

  context "empty allocation" do
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

  describe "sub allocations" do
    it "returns an enumerator" do
      expect(allocation.sub_allocations).to be_a Enumerator
    end

    it "generates 12 sub allocations" do
      expect(allocation.sub_allocations.take(3).length).to eq 3
    end

    it "yields allocations" do
      expect(allocation.sub_allocations.take(3)).to all be_a Allocation
    end

    context "small test" do
      let(:constraints) do
        Constraints.new [60, 90], {30 => 1, 45 => 1, 60 => 1}
      end
    end
  end
end
