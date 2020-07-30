# frozen_string_literal: true

module Wordbee
	module API
		module Methods


			module Orders
				def orders
					OrdersContext.new(self)
				end
			end

			include Orders

		end
	end
end

class OrdersContext < MethodContext

	def create(data, zipped_files)
		file = self.client.file_for_upload(zipped_files)
		self.client.request("/orders/new_form", method: 'POST', data: data.merge(file: file), file_upload: true)
	end

	def create_standard(data, zipped_files)
		file = self.client.file_for_upload(zipped_files)
		self.client.request("/orders", method: 'POST', data: data.merge(file: file), file_upload: true)
	end

	def find(query)
		params = {}
		params.merge({filter: query}) if query
		self.client.request("/orders", params: params)
	end

	def all
		find(nil)
	end
end

