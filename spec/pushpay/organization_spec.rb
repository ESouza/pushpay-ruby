# frozen_string_literal: true

require "spec_helper"

RSpec.describe PushPay::Organization do
  let(:orgs) { described_class.new(PushPay.client) }
  let(:base_url) { "https://api.pushpay.io" }

  describe "#find" do
    it "gets an organization by key" do
      stub_request(:get, "#{base_url}/v1/organization/org_123")
        .to_return(status: 200, body: { key: "org_123", name: "Test Org" }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = orgs.find("org_123")
      expect(result["name"]).to eq("Test Org")
    end
  end

  describe "#in_scope" do
    it "lists accessible organizations" do
      stub_request(:get, "#{base_url}/v1/organizations/in-scope")
        .to_return(status: 200, body: { items: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = orgs.in_scope
      expect(result["items"]).to eq([])
    end
  end

  describe "#campuses" do
    it "lists campuses for the configured organization" do
      stub_request(:get, "#{base_url}/v1/organization/test_org_key/campuses")
        .to_return(status: 200, body: { items: [] }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = orgs.campuses
      expect(result["items"]).to eq([])
    end
  end
end
