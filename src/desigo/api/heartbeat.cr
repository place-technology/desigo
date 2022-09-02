module Desigo
  module API
    # If a Client logs in, a session is created and bound to the bearer token that the Client receives as part of a successful login request.
    # The session and its bearer token expire after some time of inactivity (default: 10 minutes).
    # Inactivity is detected if no subscription is alive and no protected (authenticated) call is made within this timeout.
    class Heartbeat
      def initialize(@session : Session)
      end

      def signal
        @session.post("/heartbeat", {} of String => String)
      end
    end
  end
end
