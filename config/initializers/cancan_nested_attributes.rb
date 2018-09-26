module AuthorizeNestedAttributes
  module ControllerAdditions
    module ClassMethods
      def authorize_nested_attributes(*args)
        args = [only: %i[create update]] unless args.present?
        cancan_resource_class
          .add_before_action(self, :authorize_nested_attributes, *args)
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end
  end

  module ControllerResourceAdditions
    def authorize_nested_attributes
      associations_with_accepted_nested_attributes
        .each(&method(:authorize_nested_attributes_for))
    end

    def authorize_nested_attributes_for reflection
      attributes_param_name = "#{reflection.name}_attributes"
      return unless sanitize_parameters.include?(attributes_param_name)
      assoc_class = reflection.klass
      sanitize_parameters[attributes_param_name].each do |attributes|
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
        @controller.authorize! assoc_action, assoc
      end
    end

    def associations_with_accepted_nested_attributes
      resource_class.reflect_on_all_associations.select do |reflection|
        attributes_writer_name = "#{reflection.name}_attributes="
        resource_instance.respond_to?(attributes_writer_name)
      end
    end
  end
end

ActionController::Base.include(
  AuthorizeNestedAttributes::ControllerAdditions
)

CanCan::ControllerResource.include(
  AuthorizeNestedAttributes::ControllerResourceAdditions
)
