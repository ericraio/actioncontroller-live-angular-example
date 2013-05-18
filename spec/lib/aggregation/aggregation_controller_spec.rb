require "spec_helper"

describe Aggregation::AggregationController do

  describe "#self.process" do
    it "should process the data into the database" do
      Aggregation::Source::TheGamesDb.should_receive(:create_records)
      Aggregation::AggregationController.process
    end
  end

end
