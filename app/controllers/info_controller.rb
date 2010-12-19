class InfoController < ApplicationController
  def index
  	redirect_to :controller => "users", :action => "index"
  end

  def edit
  	@user = current_user
  	@user.info ||= Info.new
  	@info = @user.info
  	if accessible_parameter?(:info)
  		if @user.info.update_attributes(params[:info])
  			flash[:notice]="Info has been saved."
  			redirect_to :controller => "users", :action => "index"
  		end
  	end  			
  end

end
