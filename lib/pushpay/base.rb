# frozen_string_literal: true

module PushPay
  class Base
    attr_reader :client

    def initialize(client = nil)
      @client = client || PushPay.client
    end

    private

    def merchant_path(merchant_key = nil)
      key = merchant_key || client.configuration.merchant_key
      raise ConfigurationError, ["merchant_key"] unless key
      "/v1/merchant/#{key}"
    end

    def organization_path(organization_key = nil)
      key = organization_key || client.configuration.organization_key
      raise ConfigurationError, ["organization_key"] unless key
      "/v1/organization/#{key}"
    end
  end
end
