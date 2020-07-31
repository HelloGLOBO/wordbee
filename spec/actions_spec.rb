RSpec.describe Wordbee::API::Methods::Actions do


	it 'should define an actions object on a client' do
		client = create_client

		expect(client).to respond_to(:actions)
		expect(client).to respond_to(:projects)
		expect(client).to respond_to(:invoices)

		expect(client.actions).to respond_to(:traces)
		expect(client.projects).to respond_to(:traces)
		expect(client.invoices).to respond_to(:traces)
	end


	it 'should find action traces' do
		create_client do |client|
			expect {
				client.actions.traces
			}.not_to raise_error
		end
	end

	it 'should find projects action traces' do
		create_client do |client|
			expect {
				client.projects.traces
			}.not_to raise_error
		end
	end

	it 'should find invoices action traces' do
		create_client do |client|
			expect {
				client.invoices.traces
			}.not_to raise_error
		end
	end


end
