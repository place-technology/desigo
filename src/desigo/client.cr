module Desigo
  class Client
    Log = ::Log.for(self)

    getter commands : API::Commands
    getter heartbeat : API::Heartbeat
    getter property_values : API::PropertyValues
    getter values : API::Values

    def initialize(base_url : String, username : String, password : String, grant_type : String = "password", client_identifier : String? = nil)
      absolute_url = Path.new(base_url).join("/token").to_s
      request = Crest::Request.new(:post, absolute_url, headers: {"Content-Type" => "application/x-www-form-urlencoded"}, form: {"username" => username, "password" => password, "grant_type" => grant_type, "client_identifier" => client_identifier}, tls: OpenSSL::SSL::Context::Client.insecure)
      response = request.execute
      body = JSON.parse(response.body)

      session = Session.new(base_url, body["access_token"].to_s)

      @commands = API::Commands.new(session)
      @heartbeat = API::Heartbeat.new(session)
      @property_values = API::PropertyValues.new(session)
      @values = API::Values.new(session)
    end
  end
end
