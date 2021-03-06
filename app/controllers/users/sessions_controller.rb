# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

def resource
  :user
  
end
  # GET /resource/sign_in
  def new
    # super
   # redirect_to root_path
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

def custom_login
    
    if @user = User.find_by(name: params[:username])
      unless @user.validate!(params[:access_token])
        render json: { error: 'UNAUTHORIZED' }, status: :unauthorized and return
      end
    else
      @user = User.new(
        name: params[:username],
        email: params[:username],
        token: params[:access_token],
        # token: Digest::SHA256.hexdigest(params[:access_token]),
        valid_till:  params[:expires_in]
      )
    end

 if @user.save!
  @user.validate!(@user.token)
 resource = @user
   sign_in(resource_name, resource)
  redirect_to :root, notice: 'Thank you!'
    else
  redirect_to :root, notice: 'Please try again!'

    end
end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  
end
