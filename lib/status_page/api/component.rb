module StatusPage
  module API
    class Component < Base

      MUTABLE_ATTRIBUTES = %i[name description status]
      IMMUTABLE_ATTRIBUTES = %i[id page_id group_id created_at updated_at position]

      attr_accessor *MUTABLE_ATTRIBUTES
      attr_reader *IMMUTABLE_ATTRIBUTES

      STATUSES = %w[operational degraded_performance partial_outage major_outage]
      SUCCESS_STATUS = 'operational'

      def initialize(id, page_id)
        assign_attributes(id: id, page_id: page_id)
      end

      def get
        assign_attributes(get_resource)
      end

      def save
        assign_attributes(patch_resource({component: mutable_attributes})) if mutable_attributes.any?
      end

      def failing?
        status != SUCCESS_STATUS
      end

      def status=(status_type)
        validate_status(status_type)
        @status = status_type
      end

      def resource_path
        "pages/#{page_id}/components/#{id}.json"
      end

      def assign_attributes(attributes)
        attributes.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end

      private

      def mutable_attributes
        MUTABLE_ATTRIBUTES.inject({}) do |result, attr_name|
          result[attr_name] = send(attr_name) if send(attr_name)
          result
        end
      end

      def validate_status(status_type)
        STATUSES.include?(status_type.to_s) || raise("Status '#{status_type}' not recognized. Valid statuses: #{STATUSES}")
      end

    end
  end
end
