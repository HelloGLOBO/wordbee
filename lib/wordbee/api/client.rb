# frozen_string_literal: true

module Wordbee
  module API
    class Client
      attr_accessor :wordbee_host, :account_id, :password, :response_format, :auth_token

      def initialize(wordbee_host=nil, account_id=nil, password=nil, response_format = :json)
        @wordbee_host = wordbee_host
        @account_id = account_id
        @password = password
      end

      def connect
        _url = "/api/connect?account=#{@account_id}&pwd=#{@password}&json=#{self.is_json?}"

        response = request(_url)
        puts response
      end

      def disconnect

        @auth_token = nil
      end

      def is_json?
        return true if @response_format == :json
        false
      end

      def request(path, method = 'GET', params={}, data={}, headers={}, timeout=nil)
        url = build_uri(path)
        puts url.to_s
        puts CGI::parse(url.query)
        params.merge!(CGI::parse(url.query))
        _request(url.host, url.port, method, url.path, params, data, headers, timeout)
      end

      def _request(host, port, method, uri, params={}, data={}, headers={}, timeout=nil)

        puts "_request #{host} - #{port} - #{method} - #{uri} - #{params}"
        @http_client = Faraday.new(url: 'https://' + host + ':' + port.to_s, ssl: { verify: true }) do |f|
          f.options.params_encoder = Faraday::FlatParamsEncoder
          f.headers = headers
          f.params = params
          f.adapter Faraday.default_adapter
          f.proxy = "#{@proxy_port}://#{@proxy_auth}#{@proxy_path}" if @proxy_port && @proxy_path
          f.options.open_timeout = timeout
          f.options.timeout = timeout
        end

        puts "_request #{@http_client.inspect}"
        begin
          if method == 'GET'
            @response = @http_client.get(uri)
          else

          end
          @response = @http_client.send(method.downcase.to_sym, uri, method == 'GET' ? params : data)
        rescue StandardError => e
          puts e.message
          puts e.backtrace.inspect
        end

        puts "_request resposnse = #{@response.inspect}"

        if response.body && !response.body.empty?
          object = response.body
        elsif response.status == 400
          object = { message: 'Bad request', code: 400 }.to_json
        else
          # what to do??
        end

        object
      end

      def build_uri(path)
        url = @wordbee_host + path
        parsed_url = URI(url)
        parsed_url
      end
    end
  end
end
