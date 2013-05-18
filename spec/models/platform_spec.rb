require 'spec_helper'

describe Platform do
  it { should be_mongoid_document }
  it { should have_field(:name).of_type(String) }
  it { should have_field(:release_date).of_type(DateTime) }
  it { should have_and_belong_to_many(:games) }
end
