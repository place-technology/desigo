module Desigo
  class Session
    Log = ::Log.for(self)

    property single_request_timeout : Int32 = Constants::DEFAULT_SINGLE_REQUEST_TIMEOUT
    property user_agent : String = ["Desigo", Constants::VERSION].join(" ")

    def initialize(@base_url : String, @api_key : String)
    end

    def request(method : String, url : String, body) : Crest::Response
      url = Path.new(@base_url).join(url).to_s

      Log.debug { "Requesting an URL..." }
      Log.debug { "Request method: #{method}" }
      Log.debug { "Request URL: #{url}" }
      Log.debug { "Request body: #{body.to_json}" }

      case method
      when "GET"
        request = create_request(:get, url, body, headers: {"Authorization" => ["Bearer", @api_key].join(" "), "User-Agent" => @user_agent, "Accept" => "application/json", "Content-Type" => "application/json"})
        response = request.execute
      when "POST"
        request = create_request(:post, url, body, headers: {"Authorization" => ["Bearer", @api_key].join(" "), "User-Agent" => @user_agent, "Accept" => "application/json", "Content-Type" => "application/json"}, json: true)
        response = request.execute
      when "PUT"
        request = create_request(:put, url, body, headers: {"Authorization" => ["Bearer", @api_key].join(" "), "User-Agent" => @user_agent, "Accept" => "application/json", "Content-Type" => "application/json"}, json: true)
        response = request.execute
      when "DELETE"
        request = create_request(:delete, url, body, headers: {"Authorization" => ["Bearer", @api_key].join(" "), "User-Agent" => @user_agent, "Accept" => "application/json", "Content-Type" => "application/json"}, json: true)
        response = request.execute
      else
        raise Exception.new("The request-method type is invalid.")
      end

      Log.debug { "Request response status code: #{response.status_code}" }
      Log.debug { "Request response body: #{response.body}" }

      raise Exception.new(Constants::STATUS_CODES[response.status_code]) if (300..599).includes?(response.status_code)

      response
    end

    def get(url : String) : Crest::Response
      request("GET", url, [] of Nil)
    end

    def post(url : String, body) : Crest::Response
      request("POST", url, body)
    end

    def put(url : String, body) : Crest::Response
      request("PUT", url, body)
    end

    def delete(url : String, body) : Crest::Response
      request("DELETE", url, body)
    end

    private def create_request(method : Symbol, url : String, body, **kwargs)
      Crest::Request.new(method, url, body.to_json, **kwargs)
    end
  end
end
