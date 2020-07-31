RSpec.describe Wordbee::API::Methods::Orders do

	let(:deadline) {
		"2020-08-01T00:00:01.0000000Z"
	}

	let(:test_data) {
		{
				"reference": "globo-order-name",
				"client": {
						"companyId": 570
				},
				"sourceLanguage": "en",
				"targetLanguages": ["pl-PL", "es-ES"],
				"deadline": nil,
				"isDeadlineByFiles": true,
				"files": [
						{"name": "test.txt", "deadline": "2020-08-02T00:00:01.0000000Z"},
				],
				"customFields": [
				]
		}

	}

	let(:order_data) {
		{
				client: {
						companyId: 570,
				},
				# personId: 04645,
				option: 5,
				reference: 'globo-test-order',
				manager: 1234,
				sourceLanguage: "en",
				targetLanguages: ['es-ES'],
				domains: [1, 2],
				appointmentStartDate: DateTime.now + 1000,
				appointmentEndDate: DateTime.now + 2000,
				isAppointment: true,
				deadline: deadline,
				isDeadlineByFiles: false,
				files: [{name: test_file_name, deadline: nil}],
				customFields: [
						{key: 'custom_field_1', text: 'field 1'},
						{key: 'custom_field_2', text: 'field 2'},
				],
		}
	}

	let(:data) {
		{
				client: {
						companyId: 570,
				},
				option: 5,
				sourceLanguage: "en",
				targetLanguages: ['es-ES'],
				reference: 'globo-test-order',
				deadline: nil,
				isDeadlineByFiles: true,
				# personId: 04645,
				files: [{name: test_file_name, deadline: deadline}],
		}
	}

	xit 'should define an orders object on a client' do
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
				client.orders.create test_data, test_file
			}.not_to raise_error
		end
	end

	xit 'should create a new order with simple data' do
		create_client do |client|
			expect {
				client.orders.create data, test_file
			}.not_to raise_error
		end
	end

	xit 'should create a standard order' do
		create_client do |client|
			expect {
				client.orders.create_standard order_data, test_file
			}.not_to raise_error
		end
	end

	xit 'should find an order' do
		create_client do |client|
			expect {
				client.orders.create_standard order_data, test_file
				client.orders.find("Reference=#{order_data.reference}")
			}.not_to raise_error
		end
	end

	xit 'should find all orders' do
		create_client do |client|
			expect {
				client.orders.all
			}.not_to raise_error
		end
	end

end
