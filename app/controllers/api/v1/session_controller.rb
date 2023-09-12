class Api::V1::SessionController < ApplicationController
  skip_before_action :authorize_user, only: [:create]

  def create
    user = User.find_by(email: user_params[:email])
    if !user.present?
      render json: failed_response('Invalid email or password. Please Try again!'), status: :unauthorized
    else
      if user.authenticate(params[:password])
        render json: {
          message: 'Successfully Loggedin!',
          data: {
            name: user.full_name,
            token: user.auth_token
          }
        }, status: :ok
      else
        render json: failed_response('Invalid email or password. Please Try again!'), status: :unauthorized
      end
    end
  rescue StandardError => e
    Rails.logger.error("User Login API failed: #{e.message}")
    render json: failed_response(e.message), status: :unprocessable_entity
  end

  private

  def user_params
    params.permit(
      :email,
      :password
    )
  end
end
