# frozen_string_literal: true
require 'faraday'

module Wordbee
  module API
    class Client
      attr_accessor :wordbee_host, :account_id, :password, :response_format, :auth_token, :proxy_path

      DEFAULT_HOST = 'https://api.eu.wordbee-translator.com:32570'

      def initialize(account_id, password, host: DEFAULT_HOST, response_format: :json, proxy: nil)
        @wordbee_host = host
        @account_id = account_id
        @password = password
        @response_format = response_format
        @proxy_path = proxy

        if block_given?
          self.connect
          yield self
          self.disconnect
        end
      end

      def connect
        _url = "/api/connect?account=#{@account_id}&pwd=#{@password}&json=#{self.is_json?}"
        response = request(_url, do_struct: false)
        if response
          @auth_token = response
        end
      end

      def disconnect
        _url = "/api/disconnect?token=#{@auth_token}"
        response = request(_url, do_struct: false)
        if response && response.code && response.code.to_i == 200
          @auth_token = nil
        end
      end

      def is_json?
        return true if @response_format == :json
        false
      end

      def request(path, method: 'GET', params:{}, data:{}, headers:{}, timeout: nil, do_struct: true)
        url = build_uri(path)
        params.merge!(CGI::parse(url.query))
        _request(url.host, url.port, method, url.path, params: params, data: data, headers: headers, timeout: timeout)
      end

      def _request(host, port, method, uri, params: {}, data: {}, headers: {}, timeout: nil, do_struct: true)
        proxy_path = @proxy_path || config.proxy_path

        @http_client = Faraday.new(url: 'https://' + host + ':' + port.to_s, ssl: { verify: true }) do |f|
          f.options.params_encoder = Faraday::FlatParamsEncoder
          f.headers = headers
          f.params = params
          f.proxy = proxy_path unless proxy_path.to_s.empty?
          f.options.open_timeout = timeout
          f.options.timeout = timeout
          f.adapter Faraday.default_adapter
        end

        logger.debug "_request #{@http_client.inspect}"

        begin
          if method == 'GET'
            response = @http_client.get(uri)
          else
            response = @http_client.post(uri, data)
          end
        rescue StandardError => e
          logger.error e.message
          logger.error e.backtrace.inspect
        end

        logger.debug "_request - #{response.inspect}"

        if response.body && !response.body.empty?

					raise Wordbee::API::ClientError.new('IP Address not authorized') if response.body.include?('IP address not authorised')
					object = json = JSON.parse response.body

					object = begin
						OpenStruct.new(json)
					rescue
						json
					end if do_struct

        elsif response.status == 400
          object = OpenStruct.new({ message: 'Bad request', code: 400 })
        elsif response.status == 200
          object = OpenStruct.new({ message: 'Success', code: 200})
        else
          object = nil
        end

        object
      end

      def build_uri(path)
        url = @wordbee_host + path
        parsed_url = URI(url)
        parsed_url
			end

			def config
				Wordbee.config
      end

      def logger
        config.logger
      end
    end
  end
end
