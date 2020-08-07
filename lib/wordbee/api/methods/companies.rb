# frozen_string_literal: true

module Wordbee
  module API
    module Methods
      module Companies
        def companies(company_id = nil)
          CompaniesContext.new(self, company_id)
        end
      end
      include Companies
    end
  end
end

class CompaniesContext < MethodContext

  attr_accessor :company_id

  def initialize(context, company_id = nil)
    super context
    @company_id = company_id
  end

  def find(query)
    params = {}
    params.merge!({filter: query}) if query
    self.client.request("/companies", params: params)
  end

  def find_clients(query)
    params = {isclient: true, issupplier: false}
    params.merge!({filter: query}) if query
    self.client.request("/companies", params: params)
  end

  def find_suppliers(query)
    params = {isclient: false, issupplier: true}
    params.merge!({filter: query}) if query
    self.client.request("/companies", params: params)
  end

end

