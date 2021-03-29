class Api::V1::AuthenticationController < ApiController
  skip_before_action :authenticate_user!, only: [:create]

  def create
    user = User.find_by(email: login_params[:email])
    puts user
    if user&.valid_password?(login_params[:password])
      token = JsonWebToken.encode(sub: user.id)
      response.headers['Authorization'] = token
      render json: { token: token }
    else
      render json: { errors: 'invalid' }
    end
  end

  def fetch
    render json: current_user
  end

  def login_params
    params.require(:user).permit(:email, :password, :username)
  end
end