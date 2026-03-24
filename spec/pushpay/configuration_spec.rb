# frozen_string_literal: true

require "spec_helper"

RSpec.describe PushPay::Configuration do
  let(:config) { described_class.new }

  describe "#initialize" do
    it "sets default values" do
      expect(config.base_url).to eq("https://api.pushpay.io")
      expect(config.auth_url).to eq("https://auth.pushpay.com/pushpay/oauth/token")
      expect(config.timeout).to eq(30)
      expect(config.scopes).to eq(["read"])
    end
  end

  describe "#sandbox!" do
    it "sets sandbox URLs" do
      config.sandbox!
      expect(config.base_url).to eq("https://sandbox-api.pushpay.io")
      expect(config.auth_url).to eq("https://auth.pushpay.com/pushpay-sandbox/oauth/token")
    end
  end

  describe "#valid?" do
    it "returns true when both credentials are present" do
      config.client_id = "id"
      config.client_secret = "secret"
      expect(config.valid?).to be true
    end

    it "returns false when client_id is missing" do
      config.client_secret = "secret"
      expect(config.valid?).to be false
    end

    it "returns false when client_secret is missing" do
      config.client_id = "id"
      expect(config.valid?).to be false
    end

    it "returns false with empty strings" do
      config.client_id = ""
      config.client_secret = ""
      expect(config.valid?).to be false
    end
  end

  describe "#missing_credentials" do
    it "returns all missing fields when none set" do
      expect(config.missing_credentials).to contain_exactly("client_id", "client_secret")
    end

    it "returns empty array when all present" do
      config.client_id = "id"
      config.client_secret = "secret"
      expect(config.missing_credentials).to be_empty
    end

    it "returns only missing fields" do
      config.client_id = "id"
      expect(config.missing_credentials).to contain_exactly("client_secret")
    end
  end
end
