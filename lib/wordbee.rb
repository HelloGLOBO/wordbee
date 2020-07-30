require 'net/http'
require 'net/https'
require 'openssl'
require 'base64'
require 'time'
require 'json'
require 'cgi'

require "wordbee/version"
require "wordbee/configuration"

Dir[File.dirname(__FILE__) + '/wordbee/api/*.rb'].sort.each do |file|
  require file
end

module Wordbee
  class << self
    attr_accessor :config
  end

  def self.config
    @config ||= Wordbee::Configuration.new
  end

  def self.reset
    @config = Wordbee::Configuration.new
  end

  def self.configure
    yield(config)
  end
end
