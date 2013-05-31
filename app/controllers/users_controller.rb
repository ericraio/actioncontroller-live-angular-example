class UsersController < ApplicationController
  before_action :set_user, only: [:show, :follow_user, :unfollow_user]
  before_action :authenticate_user!, only: [:edit_profile, :update_profile]

  def show
  end

  def edit_profile
  end

  def update_profile
    if current_user.update_attributes(profile_update_params)
      flash[:notice] = "Successfully updated your profile."
    end
    redirect_to :back
  end

  def follow_user
    current_user.follow(@user) if current_user && @user
    redirect_to :back
  end

  def unfollow_user
    current_user.unfollow(@user) if current_user && @user
    redirect_to :back
  end

  private

  def set_user
    @user ||= User.where(slug: params[:slug]).first
    if @user.blank?
      redirect_to status: 404
      return
    end
  end

  def profile_update_params
    params.permit(:avatar, :cover_photo)
  end

end
