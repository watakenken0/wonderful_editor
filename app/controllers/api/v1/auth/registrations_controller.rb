class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  # def user_create
  #   binding.pry
  #   @user = User.new(sign_up_params)
  #   @user = User.save!
  #   render json: @user
  # end
  private

  def sign_up_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

end
