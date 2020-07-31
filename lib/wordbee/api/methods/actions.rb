# frozen_string_literal: true

module Wordbee
	module API

		module ObjectTypes
			PROJECT = 0
			INVOICE = 1
			STANDARD_JOB = 3
			CODYT_JOB = 4
		end

		module Methods

			module Traceable
				def action_traces(object_type: nil, date_from: nil, count: 100, start_index: 0)
					params = {}
					params[:objectType] = object_type if object_type
					params[:datefrom] = date_from if date_from
					params[:from] = start_index if start_index
					params[:count] = count if count

					self.client.request(Wordbee::API::Methods::ACTION_TRACES_URL, params: params)
				end
			end

			ACTION_TRACES_URL = "/activity/traces"

			module Actions
				def actions
					ActionsContext.new(self)
				end
			end

			include Actions

		end
	end
end



class ActionsContext < MethodContext
	include Wordbee::API::Methods::Traceable

	def traces(object_type: nil, date_from: nil, count: 100, start_index: 0)
		action_traces(object_type: object_type, date_from: date_from, count: count, start_index: start_index)
	end

end

class ProjectsContext < MethodContext
	include Wordbee::API::Methods::Traceable

	def traces(date_from: nil, count: 100, start_index: 0)
		action_traces(object_type: Wordbee::API::ObjectTypes::PROJECT, date_from: date_from, count: count, start_index: start_index)
	end
end

class InvoicesContext < MethodContext
	include Wordbee::API::Methods::Traceable

	def traces(date_from: nil, count: 100, start_index: 0)
		action_traces(object_type: Wordbee::API::ObjectTypes::INVOICE, date_from: date_from, count: count, start_index: start_index)
	end
end


