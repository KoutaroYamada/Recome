class ApplicationController < ActionController::Base
  # どのコントローラでも記事の読み込みができるように、ここに記述
  require 'open-uri'

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name])
  end

end
