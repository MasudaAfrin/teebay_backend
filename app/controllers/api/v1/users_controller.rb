class Api::V1::UsersController < ApplicationController
  skip_before_action :authorize_user, only: [:create]

  def create
    if user_params[:password] != user_params[:confirm_password]
      render json: failed_response('Password and Confirm Password do not match!'), status: :unprocessable_entity
    else
      User.create!(user_params.except(:confirm_password))
      render json: {
        message: 'Successfully user registered!',
        data: nil
      }, status: :created
    end
  rescue StandardError => e
    Rails.logger.error("User create API failed: #{e.message}")
    render json: failed_response(e.message), status: :unprocessable_entity
  end

  private

  def user_params
    params.permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :confirm_password,
      :phone_number,
      :address
    )
  end
end
