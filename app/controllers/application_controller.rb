class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :ensure_store_assigned

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
  end

  def after_sign_in_path_for(resource)
    if resource.store.present?
      posts_path
    else
      new_store_path
    end
  end

  private

  def ensure_store_assigned
    return unless user_signed_in?
    return if current_user.store.present?
    return if controller_name == "stores"
    return if controller_name == "home"
    return if devise_controller?

    redirect_to new_store_path, alert: "店舗を作成するか、既存の店舗に参加してください。"
  end
end
