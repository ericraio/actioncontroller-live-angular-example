require "spec_helper"

describe User do
  it "should include the module Mongoid::Search" do
    User.included_modules.should include(Mongoid::Search)
  end
  it "should include the module Mongo::Followable::Followed" do
    User.included_modules.should include(Mongo::Followable::Followed)
  end
  it "should include the module Mongo::Followable::Follower" do
    User.included_modules.should include(Mongo::Followable::Follower)
  end
  it "should include the module Mongo::Followable::History" do
    User.included_modules.should include(Mongo::Followable::History)
  end
  it "should include the module User::AuthDefinitions" do
    User.included_modules.should include(User::AuthDefinitions)
  end
  it "should include the module User::Roles" do
    User.included_modules.should include(User::Roles)
  end

  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should have_field(:username).of_type(String) }
  it { should have_field(:first_name).of_type(String) }
  it { should have_field(:last_name).of_type(String) }
  it { should have_field(:email).of_type(String) }
  it { should have_field(:image).of_type(String) }
  it { should have_field(:roles_mask).of_type(Integer) }

  it { should validate_presence_of(:email) }

  it { should have_many(:identities) }

  describe "#full_name" do
    it "should return the full name" do
      User.new(first_name: 'eric', last_name: 'raio').full_name.should == 'eric raio'
    end
  end

  describe "#name" do
    it "should return the name" do
      User.new(first_name: 'eric', last_name: 'raio').name.should == 'Eric R.'
    end
  end
end

