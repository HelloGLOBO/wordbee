RSpec.describe Wordbee do
	ACCOUNT_ID = "globotesting"
	PASSWORD = "8DOhgcwWDNW7iwZc"

  it "has a version number" do
    expect(Wordbee::VERSION).not_to be nil
	end

	it 'should connect' do
		client = Wordbee::API::Client.new(ACCOUNT_ID, PASSWORD)
		auth_token = client.connect
		expect(auth_token).not_to be_nil
	end

	xit 'should connect' do
		# client = Wordbee::API::Client.new(ACCOUNT_ID, PASSWORD) do |client|
		# 	auth_token = client.send(:auth_token)
		# 	expect(auth_token).not_to be_nil
		# end
		#
		# auth_token = client.send(:auth_token)
    # expect(auth_token).to be_nil
  end
end
