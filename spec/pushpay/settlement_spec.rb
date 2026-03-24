# frozen_string_literal: true

require "spec_helper"

RSpec.describe PushPay::Settlement do
  let(:settlements) { described_class.new(PushPay.client) }
  let(:base_url) { "https://api.pushpay.io" }

  describe "#find" do
    it "gets a settlement by key" do
      stub_request(:get, "#{base_url}/v1/settlement/set_123")
        .to_return(status: 200, body: { key: "set_123", name: "March Settlement" }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = settlements.find("set_123")
      expect(result["name"]).to eq("March Settlement")
    end
  end

  describe "#list" do
    it "lists settlements for a merchant" do
      stub_request(:get, "#{base_url}/v1/merchant/test_merchant_key/settlements")
        .to_return(status: 200, body: { items: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = settlements.list
      expect(result["items"]).to eq([])
    end
  end

  describe "#payments" do
    it "lists payments within a settlement" do
      stub_request(:get, "#{base_url}/v1/settlement/set_123/payments")
        .to_return(status: 200, body: { items: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = settlements.payments("set_123")
      expect(result["items"]).to eq([])
    end
  end
end
