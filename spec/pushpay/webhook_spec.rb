# frozen_string_literal: true

require "spec_helper"

RSpec.describe PushPay::Webhook do
  let(:webhooks) { described_class.new(PushPay.client) }
  let(:base_url) { "https://api.pushpay.io" }

  describe "#find" do
    it "gets a webhook by token" do
      stub_request(:get, "#{base_url}/v1/merchant/test_merchant_key/webhook/wh_123")
        .to_return(status: 200, body: { token: "wh_123" }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = webhooks.find("wh_123")
      expect(result["token"]).to eq("wh_123")
    end
  end

  describe "#list" do
    it "lists webhooks for a merchant" do
      stub_request(:get, "#{base_url}/v1/merchant/test_merchant_key/webhooks")
        .to_return(status: 200, body: { items: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = webhooks.list
      expect(result["items"]).to eq([])
    end
  end

  describe "#create" do
    it "creates a webhook" do
      params = { target: "https://example.com/webhook", eventTypes: ["payment_created"] }

      stub_request(:post, "#{base_url}/v1/merchant/test_merchant_key/webhooks")
        .with(body: params.to_json)
        .to_return(status: 201, body: { token: "wh_new" }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = webhooks.create(params)
      expect(result["token"]).to eq("wh_new")
    end
  end

  describe "#update" do
    it "updates a webhook" do
      stub_request(:put, "#{base_url}/v1/merchant/test_merchant_key/webhook/wh_123")
        .to_return(status: 200, body: { token: "wh_123" }.to_json,
                   headers: { "Content-Type" => "application/json" })

      webhooks.update("wh_123", { target: "https://example.com/new" })
    end
  end

  describe "#delete" do
    it "deletes a webhook" do
      stub_request(:delete, "#{base_url}/v1/merchant/test_merchant_key/webhook/wh_123")
        .to_return(status: 204, body: nil)

      webhooks.delete("wh_123")
    end
  end
end
