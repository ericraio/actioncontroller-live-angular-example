class Users::RegistrationsController < Devise::RegistrationsController

  def update
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end

    @user = User.find(current_user.id)
    # required for settings form to submit when password is left blank
    if @user.update_attributes(account_update_params)
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end

  %w{sign_up_params account_update_params}.each do |method|
    define_method method do
      params.require(:user).permit(:username, :first_name, :last_name, :email, :password, :password_confirmation, :current_password)
    end
  end
  private :sign_up_params, :account_update_params

end
