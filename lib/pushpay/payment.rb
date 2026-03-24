# frozen_string_literal: true

module PushPay
  class Payment < Base
    # Get a single payment by token
    def find(payment_token, merchant_key: nil)
      client.get("#{merchant_path(merchant_key)}/payment/#{payment_token}")
    end

    # List payments for a merchant
    def list(merchant_key: nil, **params)
      client.get("#{merchant_path(merchant_key)}/payments", params)
    end

    # List payments across an organization
    def list_for_organization(organization_key: nil, **params)
      client.get("#{organization_path(organization_key)}/payments", params)
    end
  end
end
