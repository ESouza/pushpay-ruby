# frozen_string_literal: true

module PushPay
  class Merchant < Base
    # Get a specific merchant
    def find(merchant_key)
      client.get("/v1/merchant/#{merchant_key}")
    end

    # Search merchants by name or handle
    def search(**params)
      client.get("/v1/merchants", params)
    end

    # List merchants accessible to the current application
    def in_scope(**params)
      client.get("/v1/merchants/in-scope", params)
    end

    # Search for merchants near a location
    def near(latitude:, longitude:, country: nil, **params)
      query = { latitude: latitude, longitude: longitude }
      query[:country] = country if country
      query.merge!(params)
      client.get("/v1/merchants/near", query)
    end
  end
end
