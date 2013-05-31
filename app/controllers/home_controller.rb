class HomeController < ApplicationController
  respond_to :json

  def index
    if signed_in?
      render action: 'dashboard'
    end
  end

  def dashboard
  end
end
