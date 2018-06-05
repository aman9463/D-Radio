class ApplicationController < ActionController::Base

	  def authenticate_user!(options={})
    if user_signed_in?
      super(options)
    else
      redirect_to root_path, alert: 'Pleas login first' ## if you want render 404 page
      ## render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
    end
  end
end
