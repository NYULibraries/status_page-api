module StatusPage
  module API
    class ComponentList < Base
      extend Forwardable
      delegate [:to_a, :to_ary, :[], :map, :each] => :@components

      attr_accessor :page_id

      def initialize(page_id)
        @page_id = page_id
      end

      def get
        @components = get_resource.map do |attributes|
          comp = Component.new attributes["id"], attributes["page_id"]
          comp.assign_attributes attributes
          comp
        end
      end

      def resource_path
        "pages/#{page_id}/components.json"
      end
    end
  end
end
