# frozen_string_literal: true
require 'faraday'

module Wordbee
  module API
    class Client
      attr_accessor :wordbee_host, :account_id, :password, :response_format, :auth_token

      DEFAULT_HOST = 'https://api.eu.wordbee-translator.com:32570'

      def initialize(account_id, password, wordbee_host=DEFAULT_HOST, response_format = :json)
        @wordbee_host = wordbee_host
        @account_id = account_id
        @password = password
        @response_format = response_format

        if block_given?
          self.connect
          yield self
          self.disconnect
        end
      end

      def connect
        _url = "/api/connect?account=#{@account_id}&pwd=#{@password}&json=#{self.is_json?}"
        response = request(_url)
        if response
          @auth_token = response
        end
      end

      def disconnect
        _url = "/api/disconnect?token=" + @auth_token
        response = request(_url)
        if response
          @auth_token = nil
        end
      end

      def is_json?
        return true if @response_format == :json
        false
      end

      def request(path, method = 'GET', params={}, data={}, headers={}, timeout=nil)
        url = build_uri(path)
        params.merge!(CGI::parse(url.query))
        _request(url.host, url.port, method, url.path, params, data, headers, timeout)
      end

      def _request(host, port, method, uri, params={}, data={}, headers={}, timeout=nil)

        @http_client = Faraday.new(url: 'https://' + host + ':' + port.to_s, ssl: { verify: true }) do |f|
          f.options.params_encoder = Faraday::FlatParamsEncoder
          f.headers = headers
          f.params = params
          f.proxy = "#{Wordbee.config.proxy_path}" if Wordbee.config.proxy_path
          f.options.open_timeout = timeout
          f.options.timeout = timeout
          f.adapter Faraday.default_adapter
        end

        puts "_request #{@http_client.inspect}"

        begin
          if method == 'GET'
            response = @http_client.get(uri)
          else
            response = @http_client.post(uri, data)
          end
        rescue StandardError => e
          puts e.message
          puts e.backtrace.inspect
        end

        puts "_request - " + response.inspect

        if response.body && !response.body.empty?
          if response.body.include?('IP address not authorised')
            raise Wordbee::API::ClientError.new('IP Address not authorized')
          end
          object = JSON.parse response.body
        elsif response.status == 400
          object = { message: 'Bad request', code: 400 }.to_json
        else
          # what to do??
          object = nil
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
