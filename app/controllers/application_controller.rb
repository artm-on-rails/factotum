class ApplicationController < ActionController::Base
  # CanCanCan's #current_ability expects #current_user
  alias_method :current_user, :current_jack

  rescue_from CanCan::AccessDenied do |exception|
    head :forbidden, content_type: 'text/html'
  end

  def self.authorize_nested_attributes_for *args
    before_action only: %i[create update] do
      authorize_nested_attributes_for(*args)
    end
  end

  private

  def authorize_nested_attributes_for resource_name, assoc_name
    sanitized_params = send("#{resource_name}_params")
    attributes_key = :"#{assoc_name}_attributes"
    return unless sanitized_params.include?(attributes_key)
    resource_class = resource_name.to_s.camelize.constantize
    assoc_class = resource_class.reflect_on_association(assoc_name).klass
    sanitized_params[attributes_key].each do |attributes|
      id = attributes[:id]
      assoc =
        id.present? ? assoc_class.find(id) : assoc_class.new(attributes)
      assoc_action =
        if attributes.include?(:_destroy)
          :destroy
        elsif assoc.new_record?
          :create
        else
          :update
        end
      authorize! assoc_action, assoc
    end
  end
end
