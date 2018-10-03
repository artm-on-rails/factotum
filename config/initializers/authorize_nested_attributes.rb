module AuthorizeNestedAttributes
  module ControllerResourceAdditions
    def self.included(base)
      base.class_eval do
        alias_method :original_load_and_authorize_resource, :load_and_authorize_resource
        def load_and_authorize_resource
          original_load_and_authorize_resource
          authorize_nested_attributes if may_have_nested_attributes?
        end
      end
    end

    def authorize_nested_attributes
      associations_with_accepted_nested_attributes
        .each(&method(:authorize_nested_attributes_for))
    end

    def may_have_nested_attributes?
      %i[create update].include?(authorization_action)
    end

    def authorize_nested_attributes_for(reflection)
      attributes_param_name = "#{reflection.name}_attributes"
      return unless sanitize_parameters.include?(attributes_param_name)
      assoc_builder = resource_instance.send(reflection.name)
      attributes_list = normalize_nested_attributes_param(
        sanitize_parameters[attributes_param_name],
        reflection
      )
      attributes_list.each do |attributes|
        id = attributes[:id]
        assoc =
          id.present? ? assoc_builder.find(id) : assoc_builder.new(attributes.except(:_destroy))
        assoc_action =
          if attributes[:_destroy]
            :destroy
          elsif assoc.new_record?
            :create
          else
            :update
          end
        any_change = assoc_action == :_destroy || attributes.except(:_destory, :id).present?
        @controller.authorize! assoc_action, assoc if any_change
        assoc_builder.destroy(assoc) if assoc.new_record?
      end
    end

    def normalize_nested_attributes_param(param, reflection)
      param = param.values if multi_object_hash?(param, reflection.macro)
      Array(param)
    end

    def multi_object_hash?(param, macro)
      macro == :has_many && !param.kind_of?(Array) && !param.include?(:id)
    end

    def associations_with_accepted_nested_attributes
      resource_class.reflect_on_all_associations.select do |reflection|
        attributes_writer_name = "#{reflection.name}_attributes="
        resource_instance.respond_to?(attributes_writer_name)
      end
    end
  end
end

CanCan::ControllerResource.include(
  AuthorizeNestedAttributes::ControllerResourceAdditions
)
