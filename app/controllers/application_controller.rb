class ApplicationController < ActionController::Base
    protect_form_forgery with: :exceptions

    before_action :authenticate_user!
    before_action :configure_permitted_parameters, if: :devise_controller?

    def after_sign_in_path_for(_resource)
        #users_url
    end

    protected

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
        devise_parameter_sanitizer.permit(:account_update) do |u|
          u.permit(:name, :email, :password, :password_confirmation, :current_password)
        end
    end
end