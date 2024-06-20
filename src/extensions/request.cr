module Crest
  class Request
    def initialize(
      method : Symbol,
      url : String,
      form = {} of String => String,
      *,
      headers = {} of String => String,
      cookies = {} of String => String,
      params = {} of String => String,
      max_redirects = 10,
      **options
    )
      @method = parse_verb(method)
      @url = url
      @headers = HTTP::Headers.new
      @cookies = HTTP::Cookies.new
      @json = options.fetch(:json, false).as(Bool)
      @params_encoder = options.fetch(:params_encoder, Crest::FlatParamsEncoder).as(Crest::ParamsEncoder.class)
      @user_agent = options.fetch(:user_agent, nil).as(String | Nil)
      @redirection_history = [] of Crest::Response
      @multipart = false

      set_headers!(headers)
      set_cookies!(cookies) unless cookies.empty?
      generate_form_data!(form) if form

      unless params.empty?
        @url = url + process_url_params(params)
      end

      @max_redirects = max_redirects

      # Disable SSL entirely for this shard.
      @tls = OpenSSL::SSL::Context::Client.insecure
      @http_client = options.fetch(:http_client, new_http_client).as(HTTP::Client)
      @auth = options.fetch(:auth, "basic").as(String)
      @user = options.fetch(:user, nil).as(String | Nil)
      @password = options.fetch(:password, nil).as(String | Nil)
      @p_addr = options.fetch(:p_addr, nil).as(String | Nil)
      @p_port = options.fetch(:p_port, nil).as(Int32 | Nil)
      @p_user = options.fetch(:p_user, nil).as(String | Nil)
      @p_pass = options.fetch(:p_pass, nil).as(String | Nil)
      @logger = options.fetch(:logger, Crest::CommonLogger.new).as(Crest::Logger)
      @logging = options.fetch(:logging, false).as(Bool)
      @handle_errors = options.fetch(:handle_errors, true).as(Bool)
      @close_connection = options.fetch(:close_connection, true).as(Bool)
      @read_timeout = options.fetch(:read_timeout, nil).as(Crest::TimeoutValue?)
      @write_timeout = options.fetch(:write_timeout, nil).as(TimeoutValue?)
      @connect_timeout = options.fetch(:connect_timeout, nil).as(TimeoutValue?)

      @http_request = HTTP::Request.new(@method, @url, body: @form_data, headers: @headers)

      set_proxy!(@p_addr, @p_port, @p_user, @p_pass)
      set_timeouts!

      yield self
    end
  end
end
