RSpec.describe Wordbee::API::Methods::Invoices do


	let(:invoice_id) { 1 }

	it 'should define an invoices object on a client' do
		client = create_client
		expect(client).to respond_to(:invoices)
		res = client.invoices
		expect(res).to respond_to(:get)
		expect(res).to respond_to(:quotes)
		expect(res).to respond_to(:lines)
	end


	it 'should get an invoice' do
		create_client do |client|
			expect {
				client.invoices(invoice_id).get
			}.not_to raise_error
		end
	end

	it 'should get all invoice lines' do
		create_client do |client|
			expect {
				client.invoices(invoice_id).lines
			}.not_to raise_error
		end
	end

	it 'should get all quotes' do
		create_client do |client|
			expect {
				client.invoices(invoice_id).quotes
			}.not_to raise_error
		end
	end

	it 'should update an invoice' do
		create_client do |client|
			expect {
				client.invoices(invoice_id).update({Status: Wordbee::API::InvoiceStatuses::PROPOSAL_ACCEPTED})
			}.not_to raise_error
		end
	end


end
