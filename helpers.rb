helpers do
  
  # This method avoids having to recover the user in each route and
  # makes it available in the instance variable current_user
  def current_user
    begin
      @current_user = User.find(session[:user_email])
    rescue
      @current_user = nil
    end
  end
  
  # This method protects the routes if the user is not logged in
  def protected!
    redirect '/login' if current_user.nil?
  end

  # This method pass a message and status to show them to the user
  def set_flash(message, status = :success)
    type = {
      :success => "is-success", 
      :error => "is-danger", 
    }
    flash[:message] = message
    flash[:message_type] = type[status]
  end
end
