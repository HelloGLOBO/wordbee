# frozen_string_literal: true
require 'logger'

module Wordbee
  class Configuration

    attr_accessor :logger, :proxy_path

    def initialize
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::WARN
    end

  end
end
