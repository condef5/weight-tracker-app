helpers do
  def current_user
    begin
      @current_user = User.find(session[:user_email])
    rescue
      @current_user = nil
    end
  end
  
  def protected!
    redirect '/login' if current_user.nil?
  end

  def set_flash(message, status = :success)
    type = {
      :success => "is-success", 
      :error => "is-danger", 
    }
    flash[:message] = message
    flash[:message_type] = type[status]
  end
end
