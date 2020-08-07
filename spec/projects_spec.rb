RSpec.describe Wordbee::API::Methods::Projects do

	let(:order_data) {
		{
				reference: "globo-order-999992",
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

	let(:project_data) {
		# TODO: fill
		{
				project_id: 1
		}
	}

	it 'should define an projects object on a client' do
		client = create_client
		expect(client).to respond_to(:projects)
		res = client.projects
		expect(res).to respond_to(:get)
		expect(res).to respond_to(:find)
		expect(res).to respond_to(:update)
	end

	it 'should show a project' do
		create_client do |client|
			expect {
				client.projects.get project_data[:project_id]
			}.not_to raise_error
		end
	end

	it 'should find projects' do
		create_client do |client|
			expect {
				client.orders.create order_data, test_file
				projects = client.projects.find("Reference=\"#{order_data[:reference]}\"")
			}.not_to raise_error
		end
	end

	it 'should update a project' do
		create_client do |client|
			expect {
				projects = client.projects.find ""
				project = projects.first
				client.projects.update project.ProjectId, project_data
			}.not_to raise_error
		end
	end

end
