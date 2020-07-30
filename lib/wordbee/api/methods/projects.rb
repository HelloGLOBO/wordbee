# frozen_string_literal: true

module Wordbee
	module API
		module Methods
			module Projects
				def projects
					ProjectsContext.new(self)
				end
			end
			include Projects
		end
	end
end

class ProjectsContext < MethodContext

	def get(project_id)
		self.client.request("/projects/#{project_id}")
	end

	def find(query)
		params = {}
		params.merge({filter: query}) if query
		self.client.request("/projects", params: params)
	end

	def update(project_id, data)
		self.client.request("/projects/#{project_id}", method: 'PUT', data: data.to_json)
	end

end

