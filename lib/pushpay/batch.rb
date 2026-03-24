# frozen_string_literal: true

module PushPay
  class Batch < Base
    # Get a specific batch
    def find(batch_key, merchant_key: nil)
      client.get("#{merchant_path(merchant_key)}/batch/#{batch_key}")
    end

    # List batches for a merchant
    def list(merchant_key: nil, **params)
      client.get("#{merchant_path(merchant_key)}/batches", params)
    end

    # List batches for an organization
    def list_for_organization(organization_key: nil, **params)
      client.get("#{organization_path(organization_key)}/batches", params)
    end

    # Get payments within a batch
    def payments(batch_key, merchant_key: nil, **params)
      client.get("#{merchant_path(merchant_key)}/batch/#{batch_key}/payments", params)
    end
  end
end
