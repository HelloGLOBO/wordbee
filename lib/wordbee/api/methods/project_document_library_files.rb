# frozen_string_literal: true

module Wordbee
	module API
		module Methods
			module ProjectDocumentLibraryFiles
				def document_library_files
					DocumentLibraryFilesContext.new self
				end
			end
		end
	end
end

class ProjectsContext < MethodContext
	include Wordbee::API::Methods::ProjectDocumentLibraryFiles
end

class DocumentLibraryFilesContext < MethodContext

	attr_reader :project_context

	def initialize(project_context)
		super project_context.context
		@project_context = project_context
	end

	def all(locale: 'en-US')
		self.client.request("#{@project_context.path}/files/#{locale}")
	end

	def download(names, locale: 'en-US')
		params = {}
		params[:names] = names
		self.client.request("#{@project_context.path}/files/#{locale}/file", params: params)
	end

	private

	def project_id
		@project_context.project_id
	end

end
