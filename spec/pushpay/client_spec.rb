# frozen_string_literal: true

require "spec_helper"
require "base64"

RSpec.describe PushPay::Client do
  let(:client) { PushPay.client }

  describe "#initialize" do
    it "creates a client instance" do
      expect(client).to be_a(described_class)
    end

    context "with missing credentials" do
      it "raises a ConfigurationError" do
        config = PushPay::Configuration.new
        expect { described_class.new(config) }.to raise_error(PushPay::ConfigurationError)
      end
    end
  end

  describe "#authenticate!" do
    it "sends Basic auth header with base64 encoded credentials" do
      client.authenticate!

      expected_auth = Base64.strict_encode64("test_client_id:test_client_secret")
      expect(WebMock).to have_requested(:post, "https://auth.pushpay.com/pushpay/oauth/token")
        .with(headers: { "Authorization" => "Basic #{expected_auth}" })
    end

    it "sets access_token from response" do
      client.authenticate!
      expect(client.access_token).to eq("test_token")
    end

    it "sets token expiration" do
      client.authenticate!
      expect(client.token_expires_at).to be > Time.now
    end

    it "raises AuthenticationError on failure" do
      stub_request(:post, "https://auth.pushpay.com/pushpay/oauth/token")
        .to_return(status: 401, body: "Unauthorized")

      expect { client.authenticate! }.to raise_error(PushPay::AuthenticationError)
    end

    it "sends read scope by default" do
      client.authenticate!

      expect(WebMock).to have_requested(:post, "https://auth.pushpay.com/pushpay/oauth/token")
        .with(body: hash_including(scope: "read"))
    end

    it "includes custom scopes when configured" do
      PushPay.configuration.scopes = %w[read merchant:view_payments]
      client.authenticate!

      expect(WebMock).to have_requested(:post, "https://auth.pushpay.com/pushpay/oauth/token")
        .with(body: hash_including(scope: "read merchant:view_payments"))
    end
  end

  describe "#get" do
    it "makes authenticated GET request" do
      stub_request(:get, "https://api.pushpay.io/v1/test")
        .to_return(status: 200, body: { data: "ok" }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = client.get("/v1/test")
      expect(result).to eq("data" => "ok")
    end

    it "sends Accept: application/hal+json header" do
      stub_request(:get, "https://api.pushpay.io/v1/test")
        .to_return(status: 200, body: {}.to_json,
                   headers: { "Content-Type" => "application/json" })

      client.get("/v1/test")
      expect(WebMock).to have_requested(:get, "https://api.pushpay.io/v1/test")
        .with(headers: { "Accept" => "application/hal+json" })
    end

    it "passes query parameters" do
      stub_request(:get, "https://api.pushpay.io/v1/test")
        .with(query: { page: "0", pageSize: "25" })
        .to_return(status: 200, body: {}.to_json,
                   headers: { "Content-Type" => "application/json" })

      client.get("/v1/test", page: "0", pageSize: "25")
    end
  end

  describe "#post" do
    it "makes authenticated POST request with JSON body" do
      stub_request(:post, "https://api.pushpay.io/v1/test")
        .with(body: { name: "test" }.to_json,
              headers: { "Content-Type" => "application/json" })
        .to_return(status: 201, body: { id: "123" }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = client.post("/v1/test", name: "test")
      expect(result).to eq("id" => "123")
    end
  end

  describe "#put" do
    it "makes authenticated PUT request" do
      stub_request(:put, "https://api.pushpay.io/v1/test")
        .to_return(status: 200, body: { success: true }.to_json,
                   headers: { "Content-Type" => "application/json" })

      result = client.put("/v1/test", name: "updated")
      expect(result).to eq("success" => true)
    end
  end

  describe "#delete" do
    it "makes authenticated DELETE request" do
      stub_request(:delete, "https://api.pushpay.io/v1/test")
        .to_return(status: 204, body: nil)

      client.delete("/v1/test")
    end
  end

  describe "error handling" do
    it "raises AuthenticationError on 401 and clears token" do
      stub_request(:get, "https://api.pushpay.io/v1/expired")
        .to_return(status: 401, body: "Unauthorized")

      expect { client.get("/v1/expired") }.to raise_error(PushPay::AuthenticationError)
      expect(client.access_token).to be_nil
    end

    it "raises NotFoundError on 404" do
      stub_request(:get, "https://api.pushpay.io/v1/missing")
        .to_return(status: 404, body: "Not Found")

      expect { client.get("/v1/missing") }.to raise_error(PushPay::NotFoundError)
    end

    it "raises RateLimitError on 429 with retry-after" do
      stub_request(:get, "https://api.pushpay.io/v1/limited")
        .to_return(status: 429, body: "Too Many Requests",
                   headers: { "retry-after" => "30" })

      expect { client.get("/v1/limited") }.to raise_error(PushPay::RateLimitError) do |error|
        expect(error.retry_after).to eq("30")
      end
    end

    it "raises ValidationError on 400 with validation failures" do
      stub_request(:post, "https://api.pushpay.io/v1/bad")
        .to_return(
          status: 400,
          body: { message: "Bad Request", validationFailures: { "name" => ["is required"] } }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      expect { client.post("/v1/bad", {}) }.to raise_error(PushPay::ValidationError) do |error|
        expect(error.errors).to eq("name" => ["is required"])
      end
    end

    it "raises APIError on 500" do
      stub_request(:get, "https://api.pushpay.io/v1/error")
        .to_return(status: 500, body: "Internal Server Error")

      expect { client.get("/v1/error") }.to raise_error(PushPay::APIError)
    end
  end
end
