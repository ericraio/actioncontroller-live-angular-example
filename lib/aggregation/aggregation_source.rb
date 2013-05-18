require 'net/http'

class Aggregation::AggregationSource

  def self.fetch_records_from_remote
    raise NotImplementedError
  end

  def self.create_records
    raise NotImplementedError
  end

end
