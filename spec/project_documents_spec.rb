RSpec.describe Wordbee::API::Methods::ProjectDocuments do


	let(:project_id) { 1 }

	it 'should define an projects object on a client' do
		client = create_client
		res = client.projects(project_id)
		expect(res).to respond_to(:documents)
		res = res.documents
		expect(res).to respond_to(:download)
	end


	it 'should download a project documents' do
		create_client do |client|
			expect {
				client.projects(project_id).documents.download project_id
			}.not_to raise_error
		end
	end


end
