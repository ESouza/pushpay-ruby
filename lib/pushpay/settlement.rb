# frozen_string_literal: true

module PushPay
  class Settlement < Base
    # Get a specific settlement
    def find(settlement_key)
      client.get("/v1/settlement/#{settlement_key}")
    end

    # List settlements for a merchant
    def list(merchant_key: nil, **params)
      client.get("#{merchant_path(merchant_key)}/settlements", params)
    end

    # List settlements for an organization
    def list_for_organization(organization_key: nil, **params)
      client.get("#{organization_path(organization_key)}/settlements", params)
    end

    # Get payments within a settlement
    def payments(settlement_key, **params)
      client.get("/v1/settlement/#{settlement_key}/payments", params)
    end
  end
end
