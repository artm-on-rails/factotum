# frozen_string_literal: true

# Base controller class
class ApplicationController < ActionController::Base
  # CanCanCan's #current_ability expects #current_user
  alias current_user current_jack

  # simple access denied handler since this is just an example
  rescue_from CanCan::AccessDenied do |_exception|
    head :forbidden, content_type: "text/html"
  end
end
