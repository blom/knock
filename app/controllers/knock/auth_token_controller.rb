require_dependency "knock/application_controller"

module Knock
  class AuthTokenController < ApplicationController
    before_action :authenticate!

    def create
      if Knock.cookie
        cookies[:auth_token] = {
          value:    auth_token.token,
          expires:  Knock.token_lifetime.from_now,
          httponly: Knock.cookie_http_only,
          secure:   Knock.cookie_secure
        }
      end

      if Knock.response_body
        render json: { jwt: auth_token.token }, status: :created
      else
        head :no_content
      end
    end

  private
    def authenticate!
      raise Knock.not_found_exception_class unless user.authenticate(auth_params[:password])
    end

    def auth_token
      AuthToken.new payload: { sub: user.id }
    end

    def user
      Knock.current_user_from_handle.call auth_params[Knock.handle_attr]
    end

    def auth_params
      params.require(:auth).permit Knock.handle_attr, :password
    end
  end
end
