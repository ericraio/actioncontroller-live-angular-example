require "spec_helper"

describe Aggregation::AggregationSource do
  describe "#self.fetch_records_from_remote" do
    it "should raise NotImplementedError" do
      expect { Aggregation::AggregationSource.fetch_records_from_remote }.to raise_error(NotImplementedError)
    end
  end

  describe "self.create_records" do
    it "should raise NotImplementedError" do
      expect { Aggregation::AggregationSource.create_records }.to raise_error(NotImplementedError)
    end
  end
end
