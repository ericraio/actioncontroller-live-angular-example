class Aggregation::AggregationController

  def self.process
    Aggregation::Source::TheGamesDb.create_records
  end

end
