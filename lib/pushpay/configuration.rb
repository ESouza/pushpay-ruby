# frozen_string_literal: true

module PushPay
  class Configuration
    attr_accessor :client_id, :client_secret, :merchant_key, :organization_key,
                  :base_url, :auth_url, :timeout, :scopes

    def initialize
      @base_url = "https://api.pushpay.io"
      @auth_url = "https://auth.pushpay.com/pushpay/oauth/token"
      @timeout = 30
      @scopes = ["read"]
    end

    def sandbox!
      @base_url = "https://sandbox-api.pushpay.io"
      @auth_url = "https://auth.pushpay.com/pushpay-sandbox/oauth/token"
      self
    end

    def valid?
      !client_id.nil? && !client_id.empty? &&
        !client_secret.nil? && !client_secret.empty?
    end

    def missing_credentials
      missing = []
      missing << "client_id" if client_id.nil? || client_id.to_s.empty?
      missing << "client_secret" if client_secret.nil? || client_secret.to_s.empty?
      missing
    end
  end
end
