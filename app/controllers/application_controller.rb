class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  def current_user
    return nil if session[:session_token].nil?
    @user ||= User.find_by(session_token: session[:session_token])
  end

  def log_in!(user)
    session[:session_token] = user.reset_session_token!
  end

  def logged_in?
    !!current_user
  end

  def log_out!
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  def is_logged_in
    unless logged_in?
      flash[:error] = ["Please sign in"]
      redirect_to new_session_url
    end
  end

  def is_moderator
    @sub = Sub.find(params[:id])
    unless current_user.id == @sub.moderator_id
      redirect_to subs_url
    end
  end

  def is_author
    @post = Post.find(params[:id])
    unless current_user.id == @post.author_id
      redirect_to subs_url
    end
  end

end
