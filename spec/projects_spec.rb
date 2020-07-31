RSpec.describe Wordbee::API::Methods::Projects do


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
				client.projects.find ""
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
