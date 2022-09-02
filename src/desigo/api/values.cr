module Desigo
  module API
    class Values
      def initialize(@session : Session)
      end

      def get(id : String)
        JSON.parse(@session.get("/values/#{id}").body)
      end
    end
  end
end
