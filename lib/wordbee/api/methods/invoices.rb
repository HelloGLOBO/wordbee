# frozen_string_literal: true

module Wordbee
	module API

		module InvoiceStatuses
			#The invoice is under preparation
			PROPOSAL_DRAFT = 0
			#The invoice is sent
			PROPOSAL_SENT = 1
			#The proposal is accepted by client
			PROPOSAL_ACCEPTED = 2
			#The invoice is a draft
			INVOICE_DRAFT = 10
			#The invoice is sent
			INVOICE_SENT = 11
			#The invoice is paid
			INVOICE_PAID = 12
			#The invoice has a problem
			INVOICE_PROBLEM = 13
			#The invoice is approved. Comes after InvoiceDraft and typically means that
			#an invoice number and date is assigned.
			INVOICE_APPROVED = 15
			#The invoice is cancelled
			CANCELLED = 20
		end

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

class ProjectsContext < MethodContext

	def quotes(project_id = self.project_id)
		self.client.request(path(project_id) + "/invoices")
	end

	alias_method :invoices, :quotes

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

	def update(params, invoice_id = @invoice_id)
		params = {
				command: params.to_json
		}
		self.client.request(invoice_path(invoice_id), method: 'PUT', params: params)
	end

	def quotes
		self.client.request("/invoices")
	end

	alias_method :invoices, :quotes
	alias_method :all, :quotes

	def lines(invoice_id = @invoice_id)
		self.client.request("#{invoice_path(invoice_id)}/lines")
	end


end

