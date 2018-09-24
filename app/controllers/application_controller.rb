class ApplicationController < ActionController::Base
  # CanCanCan's #current_ability expects #current_user
  alias_method :current_user, :current_jack

  rescue_from CanCan::AccessDenied do |exception|
    head :forbidden, content_type: 'text/html'
  end
end
