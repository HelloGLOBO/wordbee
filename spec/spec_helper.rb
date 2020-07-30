require "bundler/setup"
require "wordbee"
require 'byebug'


RSpec.shared_context "shared stuff" do

	let(:test_file) {
		File.open(File.dirname(__FILE__) + "/test.zip")
	}

	before :all do
		@account_id = ENV['WORDBEE_ACCOUNT_ID']
		@account_password = ENV['WORDBEE_ACCOUNT_PASSWORD']
		@proxies = [
				ENV['WORDBEE_PROXY_1'],
				ENV['WORDBEE_PROXY_2']
		]

		Wordbee.configure do |config|
			config.logger.level = Logger::WARN
			config.proxy_path = @proxies.first
		end
	end

	def create_client
		Wordbee::API::Client.new(@account_id, @account_password) do |client|
			yield client if block_given?
		end
	end
end

RSpec.configure do |config|
	# Enable flags like --only-failures and --next-failure
	config.example_status_persistence_file_path = ".rspec_status"

	# Disable RSpec exposing methods globally on `Module` and `main`
	config.disable_monkey_patching!

	config.expect_with :rspec do |c|
		c.syntax = :expect
	end

	config.include_context "shared stuff"
end
