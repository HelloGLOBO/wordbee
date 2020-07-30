# frozen_string_literal: true

module Wordbee
	module API
		module Methods
			module Projects
				def projects(project_id = nil)
					ProjectsContext.new(self, project_id)
				end
			end
			include Projects
		end
	end
end

class ProjectsContext < MethodContext

	attr_accessor :project_id

	def initialize(context, project_id = nil)
		super context
		@project_id = project_id
	end

	def get(project_id = self.project_id)
		self.client.request("/projects/#{project_id}")
	end

	def find(query)
		params = {}
		params.merge({filter: query}) if query
		self.client.request("/projects", params: params)
	end

	def update(project_id = self.project_id, data)
		self.client.request("/projects/#{project_id}", method: 'PUT', data: data.to_json)
	end


end

