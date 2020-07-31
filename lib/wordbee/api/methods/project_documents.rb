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

	def all
		self.client.request("#{@project_context.path}/documents")
	end

	def download(name: nil, doc_id: nil, locale: 'en')
		params = {}
		params[:name] = name if name
		params[:docid] = doc_id if doc_id
		self.client.request("#{@project_context.path}/documents/#{locale}/file", params: params)
	end

	private

	def project_id
		@project_context.project_id
	end

end

