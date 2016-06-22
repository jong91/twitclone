class SessionsController < ApplicationController
 
  def new
  end

  def create
  	@user = User.find_by(email: params[:session][:email].downcase)
  	if @user && @user.authenticate(params[:session][:password])
  		if @user.activated?
        # Log the user in and redirect to the user's show page
  		  log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
    		redirect_back_or @user
    	else
  	   	# Create a warning message if not activated
        message = "Account not activated. "
        message += "Check your email for the activation link."
  		  flash.now[:warning] = message
        redirect_to root_url
  	  end
    # User enters in wrong email and/or password
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
