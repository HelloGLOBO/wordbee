# frozen_string_literal: true

module Wordbee
	module API
		module Methods


			module Orders
				def orders(order_id = nil)
					OrdersContext.new(self, order_id)
				end
			end

			include Orders

		end
	end
end

class OrdersContext < MethodContext
	attr_accessor :order_id

	def initialize(context, order_id = nil)
		super context
		@order_id = order_id
	end


	def create(data, zipped_files = nil)
		if zipped_files
			create_with_file data, zipped_files
		else
			create_without_file data
		end
	end

	def find(query, params = {})
		params.merge!({filter: query}) if query
		self.client.request("/orders", params: params)
	end

	def all
		find(nil)
	end


	def create_with_file(data, zipped_files = nil)
		file = self.client.file_for_upload(zipped_files)
		headers = {
				"Content-Type": 'application/zip',
				"Content-Length": file.size.to_s,
		}
		self.client.request("/orders/newform", method: 'POST', data: file, params: {data: data.to_json}, headers: headers, file_upload: true)
	end

	def create_without_file(data)
		self.client.request("/orders", method: 'POST', data: data.to_json)
	end
end

