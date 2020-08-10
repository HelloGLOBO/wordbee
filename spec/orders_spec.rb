RSpec.describe Wordbee::API::Methods::Orders do

	let(:deadline) {
		"2020-08-01T00:00:01.0000000Z"
	}

	let(:test_data) {
		{
				reference: "globo-order-999991",
				client: {
						companyId: company_id
				},
				option: 5,
				sourceLanguage: "en",
				targetLanguages: ["pl-PL", "es-ES"],
				deadline: nil,
				isDeadlineByFiles: true,
				files: [
						{name: test_file_name, deadline: nil},
						{name: test_file_name2, deadline: nil}
				],
				customFields: [
						{key: "globo_portal_id", text: "123"}
				]
		}
	}

	let(:standard_test_data) {
		{
				reference: "globo-order-name-2",
				companyId: company_id,
				sourceLocale: "en",
				targetLocales: ["pl-PL", "es-ES"],
				deadline: "2018-20-01T00:00:01.0000000Z",
				instructions: "This should not be translated because it's a test",
				customFields: [
				]
		}
	}

	it 'should define an orders object on a client' do
		client = create_client
		expect(client).to respond_to(:orders)
		res = client.orders
		expect(res).to respond_to(:create)
		expect(res).to respond_to(:find)
		expect(res).to respond_to(:all)
	end

	it 'should create a new order' do
		create_client do |client|
			expect {
				client.orders.create test_data, test_file
			}.not_to raise_error
		end
	end

	it 'should create a standard order' do
		create_client do |client|
			expect {
				client.orders.create standard_test_data
			}.not_to raise_error
		end
	end

	it 'should find an order' do
		create_client do |client|
			res = nil
			expect {
				client.orders.create test_data, test_file
				res = client.orders.find("Reference=#{test_data.reference}", count: 100)
			}.not_to raise_error
			expect(res).not_to be_nil
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
