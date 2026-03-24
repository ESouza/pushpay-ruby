# frozen_string_literal: true

module PushPay
  class Webhook < Base
    # Get a specific webhook
    def find(webhook_token, merchant_key: nil)
      client.get("#{merchant_path(merchant_key)}/webhook/#{webhook_token}")
    end

    # List webhooks for a merchant
    def list(merchant_key: nil, **params)
      client.get("#{merchant_path(merchant_key)}/webhooks", params)
    end

    # Create a webhook
    def create(params, merchant_key: nil)
      client.post("#{merchant_path(merchant_key)}/webhooks", params)
    end

    # Update a webhook
    def update(webhook_token, params, merchant_key: nil)
      client.put("#{merchant_path(merchant_key)}/webhook/#{webhook_token}", params)
    end

    # Delete a webhook
    def delete(webhook_token, merchant_key: nil)
      client.delete("#{merchant_path(merchant_key)}/webhook/#{webhook_token}")
    end
  end
end
