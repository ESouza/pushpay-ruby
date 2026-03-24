# frozen_string_literal: true

require "spec_helper"

RSpec.describe PushPay::AnticipatedPayment do
  let(:anticipated) { described_class.new(PushPay.client) }
  let(:base_url) { "https://api.pushpay.io" }

  describe "#create" do
    it "creates an anticipated payment" do
      stub_request(:post, "#{base_url}/v1/merchant/test_merchant_key/anticipatedpayments")
        .with(body: { amount: "50.00" }.to_json)
        .to_return(status: 201, body: { status: "Unassociated" }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = anticipated.create({ amount: "50.00" })
      expect(result["status"]).to eq("Unassociated")
    end
  end

  describe "#list" do
    it "lists anticipated payments" do
      stub_request(:get, "#{base_url}/v1/merchant/test_merchant_key/anticipatedpayments")
        .to_return(status: 200, body: { items: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = anticipated.list
      expect(result["items"]).to eq([])
    end
  end
end
