# frozen_string_literal: true

module PushPay
  class RecurringPayment < Base
    # Get a single recurring payment by token
    def find(payment_token, merchant_key: nil)
      client.get("#{merchant_path(merchant_key)}/recurringpayment/#{payment_token}")
    end

    # List recurring payments for a merchant
    def list(merchant_key: nil, **params)
      client.get("#{merchant_path(merchant_key)}/recurringpayments", params)
    end

    # List recurring payments across an organization
    def list_for_organization(organization_key: nil, **params)
      client.get("#{organization_path(organization_key)}/recurringpayments", params)
    end

    # List payments linked to a recurring payment schedule
    def payments(payment_token, merchant_key: nil, **params)
      client.get("#{merchant_path(merchant_key)}/recurringpayment/#{payment_token}/payments", params)
    end
  end
end
