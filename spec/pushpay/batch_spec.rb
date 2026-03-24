# frozen_string_literal: true

require "spec_helper"

RSpec.describe PushPay::Batch do
  let(:batches) { described_class.new(PushPay.client) }
  let(:base_url) { "https://api.pushpay.io" }

  describe "#find" do
    it "gets a batch by key" do
      stub_request(:get, "#{base_url}/v1/merchant/test_merchant_key/batch/batch_123")
        .to_return(status: 200, body: { key: "batch_123", name: "March Batch" }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = batches.find("batch_123")
      expect(result["name"]).to eq("March Batch")
    end
  end

  describe "#list" do
    it "lists batches for a merchant" do
      stub_request(:get, "#{base_url}/v1/merchant/test_merchant_key/batches")
        .to_return(status: 200, body: { items: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = batches.list
      expect(result["items"]).to eq([])
    end
  end

  describe "#payments" do
    it "lists payments within a batch" do
      stub_request(:get, "#{base_url}/v1/merchant/test_merchant_key/batch/batch_123/payments")
        .to_return(status: 200, body: { items: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = batches.payments("batch_123")
      expect(result["items"]).to eq([])
    end
  end
end
