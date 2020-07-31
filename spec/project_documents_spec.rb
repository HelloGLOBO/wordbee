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
				project = client.projects.all.first
				project_context = client.projects(project.ProjectId)

				documents = project_context.documents
				document = documents.all.first

				documents.download doc_id: document.DocumentId, name: document.Name
			}.not_to raise_error
		end
	end


end
