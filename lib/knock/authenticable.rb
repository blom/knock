module Knock::Authenticable
  def self.included(base)
    base.include ActionController::Cookies
  end

  def current_user
    @current_user ||= begin
      token = params[:token] || auth_cookie || request.headers['Authorization'].split.last
      Knock::AuthToken.new(token: token).current_user
    rescue
      nil
    end
  end

  def authenticate
    head :unauthorized unless current_user
  end

  private

  def auth_cookie
    cookies[:auth_token] if Knock.cookie
  end
end
