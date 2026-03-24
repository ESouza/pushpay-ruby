# frozen_string_literal: true

require "spec_helper"

RSpec.describe PushPay::Payment do
  let(:payments) { described_class.new(PushPay.client) }
  let(:base_url) { "https://api.pushpay.io" }

  describe "#find" do
    it "gets a payment by token" do
      stub_request(:get, "#{base_url}/v1/merchant/test_merchant_key/payment/pay_123")
        .to_return(status: 200, body: { paymentToken: "pay_123", status: "Success" }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = payments.find("pay_123")
      expect(result["paymentToken"]).to eq("pay_123")
    end

    it "uses a custom merchant key" do
      stub_request(:get, "#{base_url}/v1/merchant/custom_key/payment/pay_123")
        .to_return(status: 200, body: { paymentToken: "pay_123" }.to_json,
                   headers: { "Content-Type" => "application/json" })

      payments.find("pay_123", merchant_key: "custom_key")
    end
  end

  describe "#list" do
    it "lists merchant payments" do
      stub_request(:get, "#{base_url}/v1/merchant/test_merchant_key/payments")
        .to_return(status: 200, body: { page: 0, pageSize: 25, items: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = payments.list
      expect(result["items"]).to eq([])
    end

    it "passes filter params" do
      stub_request(:get, "#{base_url}/v1/merchant/test_merchant_key/payments")
        .with(query: { status: "Success", pageSize: "10" })
        .to_return(status: 200, body: { items: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      payments.list(status: "Success", pageSize: "10")
    end
  end

  describe "#list_for_organization" do
    it "lists payments across an organization" do
      stub_request(:get, "#{base_url}/v1/organization/test_org_key/payments")
        .to_return(status: 200, body: { items: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = payments.list_for_organization
      expect(result["items"]).to eq([])
    end
  end
end
