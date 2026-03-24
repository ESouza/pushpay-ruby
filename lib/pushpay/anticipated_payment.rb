# frozen_string_literal: true

module PushPay
  class AnticipatedPayment < Base
    # Create a new anticipated payment
    def create(params, merchant_key: nil)
      client.post("#{merchant_path(merchant_key)}/anticipatedpayments", params)
    end

    # List anticipated payments for a merchant
    def list(merchant_key: nil, **params)
      client.get("#{merchant_path(merchant_key)}/anticipatedpayments", params)
    end
  end
end
