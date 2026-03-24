# frozen_string_literal: true

require "spec_helper"

RSpec.describe PushPay::Merchant do
  let(:merchants) { described_class.new(PushPay.client) }
  let(:base_url) { "https://api.pushpay.io" }

  describe "#find" do
    it "gets a merchant by key" do
      stub_request(:get, "#{base_url}/v1/merchant/mk_123")
        .to_return(status: 200, body: { key: "mk_123", name: "Test Church" }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = merchants.find("mk_123")
      expect(result["name"]).to eq("Test Church")
    end
  end

  describe "#search" do
    it "searches merchants by name" do
      stub_request(:get, "#{base_url}/v1/merchants")
        .with(query: { name: "Test" })
        .to_return(status: 200, body: { items: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = merchants.search(name: "Test")
      expect(result["items"]).to eq([])
    end
  end

  describe "#in_scope" do
    it "lists accessible merchants" do
      stub_request(:get, "#{base_url}/v1/merchants/in-scope")
        .to_return(status: 200, body: { items: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = merchants.in_scope
      expect(result["items"]).to eq([])
    end
  end

  describe "#near" do
    it "searches nearby merchants" do
      stub_request(:get, "#{base_url}/v1/merchants/near")
        .with(query: { latitude: "37.7749", longitude: "-122.4194", country: "US" })
        .to_return(status: 200, body: { items: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = merchants.near(latitude: "37.7749", longitude: "-122.4194", country: "US")
      expect(result["items"]).to eq([])
    end
  end
end
