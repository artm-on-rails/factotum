# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # CanCanCan's #current_ability expects #current_user
  alias current_user current_jack

  rescue_from CanCan::AccessDenied do |_exception|
    head :forbidden, content_type: "text/html"
  end
end
