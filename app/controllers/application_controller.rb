# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

	filter_parameter_logging :password
	
	helper_method :current_user
	
	def accessible_parameter? (param_to_check)
		request.post? and params[param_to_check]	
	end
	
	private
	
	def current_user_session
	  return @current_user_session if defined?(@current_user_session)
	  @current_user_session = UserSession.find
	end
	
	def current_user
	  return @current_user if defined?(@current_user)
	  @current_user = current_user_session && current_user_session.record
	end  
	
	def ensure_authenticated 
	   unless (!current_user.nil?) and (current_user.username == ADMIN_ACCOUNT)
		flash[:notice] = "NOT AUTHORIZED"
		redirect_to :root
	   end
    end
end
