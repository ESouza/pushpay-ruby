# frozen_string_literal: true

require "spec_helper"

RSpec.describe PushPay::RecurringPayment do
  let(:recurring) { described_class.new(PushPay.client) }
  let(:base_url) { "https://api.pushpay.io" }

  describe "#find" do
    it "gets a recurring payment by token" do
      stub_request(:get, "#{base_url}/v1/merchant/test_merchant_key/recurringpayment/rp_123")
        .to_return(status: 200, body: { paymentToken: "rp_123" }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = recurring.find("rp_123")
      expect(result["paymentToken"]).to eq("rp_123")
    end
  end

  describe "#list" do
    it "lists merchant recurring payments" do
      stub_request(:get, "#{base_url}/v1/merchant/test_merchant_key/recurringpayments")
        .to_return(status: 200, body: { items: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = recurring.list
      expect(result["items"]).to eq([])
    end
  end

  describe "#payments" do
    it "lists payments linked to a recurring schedule" do
      stub_request(:get, "#{base_url}/v1/merchant/test_merchant_key/recurringpayment/rp_123/payments")
        .to_return(status: 200, body: { items: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = recurring.payments("rp_123")
      expect(result["items"]).to eq([])
    end
  end
end
