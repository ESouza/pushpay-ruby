# frozen_string_literal: true

module PushPay
  class Fund < Base
    # Get a specific fund
    def find(fund_key, organization_key: nil)
      client.get("#{organization_path(organization_key)}/fund/#{fund_key}")
    end

    # List funds for a merchant
    def list(merchant_key: nil, **params)
      client.get("#{merchant_path(merchant_key)}/funds", params)
    end

    # List funds for an organization
    def list_for_organization(organization_key: nil, **params)
      client.get("#{organization_path(organization_key)}/funds", params)
    end

    # Create a fund
    def create(params, organization_key: nil)
      client.post("#{organization_path(organization_key)}/funds", params)
    end

    # Update a fund
    def update(fund_key, params, organization_key: nil)
      client.put("#{organization_path(organization_key)}/fund/#{fund_key}", params)
    end

    # Change fund status (open/close)
    def update_status(fund_key, params, organization_key: nil)
      client.patch("#{organization_path(organization_key)}/fund/#{fund_key}", params)
    end

    # Delete a fund
    def delete(fund_key, organization_key: nil)
      client.delete("#{organization_path(organization_key)}/fund/#{fund_key}")
    end
  end
end
