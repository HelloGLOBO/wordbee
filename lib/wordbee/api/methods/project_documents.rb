# frozen_string_literal: true

module Wordbee
	module API
		module Methods
			module ProjectDocuments
				def documents
					DocumentsContext.new self
				end
			end
		end
	end
end

class ProjectsContext < MethodContext
	include Wordbee::API::Methods::ProjectDocuments
end

class DocumentsContext < MethodContext

	attr_reader :project_context

	def initialize(project_context)
		super project_context.context
		@project_context = project_context
	end


	def download(locale = 'en')
		self.client.request("#{project_path}/documents/#{locale}/file")
	end

	private

	def project_path
		"/projects/#{@project_context.project_id}"
	end

	def project_id
		@project_context.project_id
	end

end

