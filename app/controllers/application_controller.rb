class ApplicationController < ActionController::API

  include DeviseTokenAuth::Concerns::SetUserByToken


  attr_reader :current_user
  include CanCan::ControllerAdditions
  
  def authenticate_request!
    unless user_id_in_token?
      render json: { errors: ['Not Authenticated'] }, status: :unauthorized
      return
    end
    @current_user = User.find(auth_token[:user_id])
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end

  rescue_from CanCan::AccessDenied do |exception|
    render json: { errors: ['Please, login.'] }, status: 401
    # render json: { head: :forbidden, content_type: 'text/html', errors['Please, login.'], status: 401}
      # respond_to do |format|
      #   # format.html { redirect_to new_user_session_path }
      #   format.js   { head :forbidden, content_type: 'text/html' }
      #   format.json { render json: {errors: ['Please, login.'], status: 401}}
      # end
  end

end
