require "bundler/setup"
require "wordbee"
require 'byebug'


RSpec.shared_context "shared stuff" do
	test_zip_name = 'test.zip'
	test_file_name = 'test.txt'
	test_file_name2 = 'test2.txt'

	let(:company_id) {
		ENV['WORDBEE_COMPANY_ID'] || 1444
	}

	let(:test_file_name) { test_file_name }
	let(:test_file_name2) { test_file_name2 }
	let(:test_zip_name) { test_zip_name }

	let(:test_file) {
		File.open(File.dirname(__FILE__) + "/#{test_zip_name}")
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
