module Desigo
  module API
    class PropertyValues
      def initialize(@session : Session)
      end

      def get(id : String)
        JSON.parse(@session.get("/propertyvalues/#{id}").body)
      end
    end
  end
end
