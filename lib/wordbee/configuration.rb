# frozen_string_literal: true

module Wordbee
  class Configuration

    attr_accessor :logger, :proxy_path

    def initialize
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::WARN
    end

  end
end
