# frozen_string_literal: true

module Wordbee
  class Configuration

    attr_accessor :logger, :proxy_path, :proxy_port, :proxy_auth

    def initialize
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::WARN
    end

  end
end
