module StatusPage
  module API
    class Base
      # sends request to status page API for given path and method, passing any other options through to RestClient
      # parses the response and returns as a ruby hash or array
      def execute(path, method:, **options)
        default_options = {headers: authentication_headers, method: method, url: get_full_url(path)}
        JSON.parse RestClient::Request.execute default_options.merge(options)
      rescue RestClient::UnprocessableEntity => e
        error_message = JSON.parse(e.response)["error"].join(", ")
        raise error_message
      end

      private

      def get_full_url(subpath)
        "https://api.statuspage.io/v1/pages/#{page_id}/#{subpath}"
      end

      def authentication_headers
        {'Authorization' => "OAuth #{api_key}"}
      end

      def api_key
        ENV['STATUS_PAGE_API_KEY'] || raise("Must specify STATUS_PAGE_API_KEY to use StatusPage")
      end

      def page_id
        ENV['STATUS_PAGE_PAGE_ID'] || raise("Must specify STATUS_PAGE_PAGE_ID to use StatusPage")
      end
    end
  end
end
