RSpec.describe Wordbee::API::Methods::Orders do


	let(:order_data) {
		{
				client: {
						companyId: 123,
						personId: 123,
				},
				option: 123,
				deadline: DateTime.now + 1000,
				reference: "reference",
				manager: 1234,
				sourceLanguage: "en",
				targetLanguages: ['es-ES'],
				domains: [1, 2],
				appointmentStartDate: DateTime.now + 1000,
				appointmentEndDate: DateTime.now + 2000,
				isAppointment: true,
				isDeadlineByFiles: false,
				files: ["file1.name", "file2.name"],
				customFields: [
						{key: 'custom_field_1', text: 'field 1'},
						{key: 'custom_field_2', text: 'field 2'},
				],
		}
	}

	it 'should define an orders object on a client' do
		client = create_client
		expect(client).to respond_to(:orders)
		res = client.orders
		expect(res).to respond_to(:create)
		expect(res).to respond_to(:create_standard)
		expect(res).to respond_to(:find)
	end


	it 'should create a new order' do
		create_client do |client|
			expect {
				client.orders.create order_data, test_file
			}.not_to raise_error
		end
	end

	it 'should create a standard order' do
		create_client do |client|
			expect {
				client.orders.create_standard order_data, test_file
			}.not_to raise_error
		end
	end

	it 'should find an order' do
		create_client do |client|
			expect {
				client.orders.create_standard order_data, test_file
				client.orders.find("Reference=#{order_data.reference}")
			}.not_to raise_error
		end
	end

	it 'should find all orders' do
		create_client do |client|
			expect {
				client.orders.all
			}.not_to raise_error
		end
	end

end
