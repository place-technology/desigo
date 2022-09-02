module Desigo
  module API
    class Commands
      def initialize(@session : Session)
      end

      def get(id : String)
        JSON.parse(@session.get("/commands/#{id}").body)
      end

      def execute(id : String, property_name : String, command_id : String, command_inputs_for_execution : Array(Hash))
        body = [
          {
            "CommandInputForExecution": command_inputs_for_execution,
            "PropertyId":               [id, ";.", property_name].join,
            "CommandId":                command_id,
          },
        ]

        JSON.parse(@session.post("/commands/propertycommand", body).body)
      end
    end
  end
end
