RSpec.describe Wordbee::API::Methods::ProjectFiles do


	before :all do
		create_client do |client|
			project = client.projects.all.first
			@project_id = project.ProjectId
		end
	end

	it 'should define an projects object on a client' do
		client = create_client
		res = client.projects(@project_id)
		expect(res).to respond_to(:files)
		res = res.files
		expect(res).to respond_to(:upload)
		expect(res).to respond_to(:set_translation_mode)
	end


	it 'should upload a project file' do
		create_client do |client|
			expect {
				client.projects(@project_id).files.upload test_file
			}.not_to raise_error
		end
	end

	it 'should set_translation_mode to a project file' do
		create_client do |client|
			expect {
				client.projects(@project_id).files.set_translation_mode Wordbee::API::TranslationModes::DO_NOT_TRANSLATE, test_zip_name
			}.not_to raise_error
		end
	end


end
