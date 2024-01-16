# frozen_string_literal: true

RSpec.describe Wordbee::API::Methods::ProjectDocumentLibraryFiles do


	let(:project_id) { 1 }

	it 'should define an projects object on a client' do
		client = create_client
		res = client.projects(project_id)
		expect(res).to respond_to(:document_library_files)
		res = res.document_library_files
		expect(res).to respond_to(:download)
	end


	it 'should download a project documents' do
		create_client do |client|
			expect {
				project = client.projects.all.first
				project_context = client.projects(project.ProjectId)

				locale = project.TargetLocales.first
				documents = project_context.document_library_files
				document = documents.all(locale: locale).first

				documents.download document.Name, locale: locale
			}.not_to raise_error
		end
	end


end
