RSpec.describe Wordbee do


	context 'config' do
		it 'should persists settings in singletong' do
			Wordbee.configure do |config|
				config.proxy_path = @proxies.first
			end

			expect(Wordbee.config.proxy_path).to eql @proxies.first
		end
	end

	context 'client' do

		context 'with config' do

			before :all do
				Wordbee.configure do |config|
					config.proxy_path = @proxies.first
				end
			end

			it 'should connect' do
				client = Wordbee::API::Client.new(@account_id, @account_password)
				auth_token = client.connect
				expect(auth_token).not_to be_nil
			end

			it 'should disconnect' do
				client = Wordbee::API::Client.new(@account_id, @account_password)
				client.connect
				client.disconnect
				auth_token = client.auth_token
				expect(auth_token).to be_nil
			end

			it 'should connect with block' do
				Wordbee::API::Client.new(@account_id, @account_password) do |c|
					auth_token = c.auth_token
					expect(auth_token).not_to be_nil
				end
			end

		end

		context 'without config' do


			it "has a version number" do
				expect(Wordbee::VERSION).not_to be nil
			end

			it 'should connect' do
				client = Wordbee::API::Client.new(@account_id, @account_password, proxy: @proxies.sample)
				auth_token = client.connect
				expect(auth_token).not_to be_nil
			end

			it 'should disconnect' do
				client = Wordbee::API::Client.new(@account_id, @account_password, proxy: @proxies.sample)
				client.connect
				client.disconnect
				auth_token = client.auth_token
				expect(auth_token).to be_nil
			end

		end


	end

end
