module StatusPage
  module API
    class Exception < StandardError
      attr_reader :rest_client_error

      def initialize(rest_client_error)
        @rest_client_error = rest_client_error
        super(message)
      end

      # generates message from original error and JSON response
      def message
        "#{rest_client_error.message} (#{response})"
      end

      # parses error from JSON response if possible
      # if invalid JSON, or JSON missing "error" key, returns full JSON string
      def response
        return "NO RESPONSE" unless rest_client_error.response
        error_text = JSON.parse(rest_client_error.response)["error"]
        error_text.is_a?(Array) ? error_text.join(", ") : error_text
      rescue JSON::ParserError
        rest_client_error.response
      rescue NoMethodError
        rest_client_error.response
      end
    end
  end
end
