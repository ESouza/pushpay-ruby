# frozen_string_literal: true

require "spec_helper"

RSpec.describe PushPay::Fund do
  let(:funds) { described_class.new(PushPay.client) }
  let(:base_url) { "https://api.pushpay.io" }

  describe "#find" do
    it "gets a fund by key" do
      stub_request(:get, "#{base_url}/v1/organization/test_org_key/fund/fund_123")
        .to_return(status: 200, body: { key: "fund_123", name: "General" }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = funds.find("fund_123")
      expect(result["name"]).to eq("General")
    end
  end

  describe "#list" do
    it "lists funds for a merchant" do
      stub_request(:get, "#{base_url}/v1/merchant/test_merchant_key/funds")
        .to_return(status: 200, body: { items: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = funds.list
      expect(result["items"]).to eq([])
    end
  end

  describe "#create" do
    it "creates a fund" do
      stub_request(:post, "#{base_url}/v1/organization/test_org_key/funds")
        .with(body: { name: "Missions", taxDeductible: true }.to_json)
        .to_return(status: 201, body: { key: "fund_new", name: "Missions" }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = funds.create({ name: "Missions", taxDeductible: true })
      expect(result["name"]).to eq("Missions")
    end
  end

  describe "#update" do
    it "updates a fund" do
      stub_request(:put, "#{base_url}/v1/organization/test_org_key/fund/fund_123")
        .to_return(status: 200, body: { key: "fund_123", name: "Updated" }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = funds.update("fund_123", { name: "Updated" })
      expect(result["name"]).to eq("Updated")
    end
  end

  describe "#delete" do
    it "deletes a fund" do
      stub_request(:delete, "#{base_url}/v1/organization/test_org_key/fund/fund_123")
        .to_return(status: 204, body: nil)

      funds.delete("fund_123")
    end
  end
end
