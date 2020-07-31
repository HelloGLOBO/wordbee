RSpec.describe Wordbee::API::Methods::Companies do

  it 'should define an companies object on a client' do
    client = create_client
    expect(client).to respond_to(:companies)
    res = client.companies
    expect(res).to respond_to(:find)
    expect(res).to respond_to(:find_clients)
    expect(res).to respond_to(:find_suppliers)
  end

  it 'should find a company' do
    create_client do |client|
      expect {
        client.companies.find "IsActive=true"
      }.not_to raise_error
    end
  end

  it 'should find a supplier' do
    create_client do |client|
      expect {
        client.companies.find_suppliers "IsActive=true"
      }.not_to raise_error
    end
  end

  it 'should find a client' do
    create_client do |client|
      expect {
        client.companies.find_clients "IsActive=true"
      }.not_to raise_error
    end
  end

end
