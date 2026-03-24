# frozen_string_literal: true

module PushPay
  class Organization < Base
    # Get a specific organization
    def find(organization_key)
      client.get("/v1/organization/#{organization_key}")
    end

    # Search organizations
    def search(**params)
      client.get("/v1/organizations", params)
    end

    # List organizations accessible to the current application
    def in_scope(**params)
      client.get("/v1/organizations/in-scope", params)
    end

    # List campuses for an organization
    def campuses(organization_key: nil, **params)
      client.get("#{organization_path(organization_key)}/campuses", params)
    end

    # List merchant listings for an organization
    def merchant_listings(organization_key: nil, **params)
      client.get("#{organization_path(organization_key)}/merchantlistings", params)
    end
  end
end
