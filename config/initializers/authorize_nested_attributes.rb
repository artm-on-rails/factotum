module AuthorizeNestedAttributes
  # Methods that will be added to the CanCan::ControllerResource to
  # implement nested attributes authorization.
  #
  # After monkey patching, this functionality will be triggered by using
  # either `load_and_authorize_resource` or `authorize_resource` in the
  # controller.
  #
  # When authorizing a resource (model) the nested attribues authorizer looks
  # in the submitted params (perhaps sanitized by strong Parameters, see
  # https://github.com/CanCanCommunity/cancancan#32-strong-parameters), for
  # keys corresponding to accepts_nested_attributes_for associations of the
  # resource. So if Jack accepts_nested_attributes_for :occupations, the
  # authorizer will look for params[:jack][:occupations_attributes]. It will
  # then build/load temporary models from nested attributes and authorize
  # current_ability's access to each of them.
  #
  # The temporary nested resources are discarded afterwards so that the standard
  # mass assignment controller code doesn't look any different from the
  # traditional CanCanCan-based code.
  module ControllerResourceAdditions
    # the main entry of the extension: authorize nested attributes for the
    # previously loaded resource and sanitized parameters
    def authorize_nested_attributes
      associations_with_accepted_nested_attributes
        .each(&method(:authorize_nested_attributes_for))
    end

    # find associations that accept nested attributes (by looking for presence
    # of #<ASSOCIATION_NAME>_attributes= method)
    def associations_with_accepted_nested_attributes
      resource_class.reflect_on_all_associations.select do |reflection|
        attributes_writer_name = "#{reflection.name}_attributes="
        resource_instance.respond_to?(attributes_writer_name)
      end
    end

    # authorize nested attributes for a single association denoted by
    # ActiveRecord::Reflection::AssociationReflection
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

    # nested attributes are only expected / authorized in certain circumstances
    def may_have_nested_attributes?
      %i[create update].include?(authorization_action)
    end

    # monkey patch the extension onto `authorize_resource` macro of CanCanCan
    def self.included(base)
      base.class_eval do
        alias_method :original_authorize_resource, :authorize_resource
        def authorize_resource
          original_authorize_resource
          authorize_nested_attributes if may_have_nested_attributes?
        end
      end
    end
  end
end

CanCan::ControllerResource.include(
  AuthorizeNestedAttributes::ControllerResourceAdditions
)
