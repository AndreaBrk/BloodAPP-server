class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    'https://avbapp.herokuapp.com/login' # Or :prefix_to_your_route
  end
end