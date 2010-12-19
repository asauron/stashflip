class ProfileController < ApplicationController
	helper :profile, :friendship
	
  def index
  end

  def show
	username = params[:username]
	@user = User.find_by_username(username)
	
	#@current_user = current_user
	#@current_user.info ||= Info.new
	#@current_info = @current_user.info
		
	if @user
		@title = "#{username}'s Public Profile"
		@info = @user.info ||= Info.new		
	else
		flash[:notice] = "{#{username} does not exist}"
		redirect_to :action => "index"
	end
				
  end

end
