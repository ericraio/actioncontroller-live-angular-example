require 'spec_helper'

describe ApplicationController do

  it "should inherit from ActionController::Base" do
    ApplicationController.superclass.should eq(ActionController::Base)
  end

end
