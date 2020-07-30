# frozen_string_literal: true
require 'faraday'
require 'wordbee/api/methods'

module Wordbee
  module API
    class Client
      include Wordbee::API::Methods
      attr_accessor :wordbee_host, :account_id, :password, :response_format, :auth_token, :proxy_path

      DEFAULT_HOST = 'https://api.eu.wordbee-translator.com:32570'

      def initialize(account_id, password, host: DEFAULT_HOST, response_format: :json, proxy: nil)
        @wordbee_host = host
        @account_id = account_id
        @password = password
        @response_format = response_format
        @proxy_path = proxy

        do_connected do
          yield self
        end if block_given?
      end

      def do_connected
        return unless block_given?
        self.connect
        yield self
        self.disconnect
      end

      def connect
        response = request("/api/connect", do_struct: false, params: {
            account: @account_id,
            pwd: @password,
            json: self.is_json?,
        })
        if response
          @auth_token = response
        end
      end

      def disconnect
        response = request("/api/disconnect", do_struct: false, params: {token: @auth_token})
        if response && response.code && response.code.to_i == 200
          @auth_token = nil
        end
      end

      def is_json?
        return true if @response_format == :json
        false
      end

      def request(path, method: 'GET', params:{}, data:{}, headers:{}, timeout: nil, do_struct: true, file_upload: false)
        url = build_uri(path)
        params.merge!(CGI::parse(url.query)) if url.query
        _request(url.host, url.port, method, url.path, params: params, data: data, headers: headers, timeout: timeout, file_upload: file_upload)
      end

      def _request(host, port, method, uri, params: {}, data: {}, headers: {}, timeout: nil, do_struct: true, file_upload: false)
        proxy_path = @proxy_path || config.proxy_path

        @http_client = Faraday.new(url: 'https://' + host + ':' + port.to_s, ssl: { verify: true }) do |f|
          f.options.params_encoder = Faraday::FlatParamsEncoder
          f.headers = headers
          f.params = params
          f.proxy = proxy_path unless proxy_path.to_s.empty?
          f.options.open_timeout = timeout
          f.options.timeout = timeout
          f.request :multipart if file_upload
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
          raise Wordbee::API::ClientError.new(e)
        end

        logger.debug "_request - #{response.inspect}"

        if response.status > 299
          if response.body && response.body.include?('IP address not authorised')
            raise Wordbee::API::ClientError.new('IP Address not authorized')
          else
            raise Wordbee::API::ClientError.new(parse_response(response, false).to_s)
          end
        end

        if response.body && !response.body.empty?
          object = parse_response(response, do_struct)
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

      def file_for_upload(file)
        Faraday::UploadIO.new(file.path, 'application.zip')
      end

      private

      def parse_response(response, do_struct)
        object = json = begin
                 JSON.parse response.body
               rescue
                 response.body
               end

        object = begin
                   OpenStruct.new(json)
                 rescue
                   json
                 end if do_struct

        logger.debug "_response #{object.inspect}"

        object
      end
    end
  end
end
