# frozen_string_literal: true

module Wordbee
	module API
		module Methods
			module Invoices
				def invoices(invoice_id = nil)
					InvoicesContext.new(self, invoice_id)
				end
			end
			include Invoices
		end
	end
end

class InvoicesContext < MethodContext

	attr_accessor :invoice_id

	def initialize(context, invoice_id = nil)
		super context
		@invoice_id = invoice_id
	end

	def invoice_path(invoice_id = @invoice_id)
		"/invoices/#{invoice_id}"
	end

	def get(invoice_id = @invoice_id)
		self.client.request("#{invoice_path(invoice_id)}")
	end

	def quotes
		self.client.request("/invoices")
	end

	def lines(invoice_id = @invoice_id)
		self.client.request("#{invoice_path(invoice_id)}")
	end


end

