class ApplicationController < ActionController::Base
  # https://qiita.com/yuki82511988/items/73659af9d1049bd1b256
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
