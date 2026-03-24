# frozen_string_literal: true

require "bundler/setup"
require "pushpay"
require "webmock/rspec"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = "spec/examples.txt"
  config.disable_monkey_patching!
  config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = "doc"
  end

  config.order = :random
  Kernel.srand config.seed

  config.before(:each) do
    WebMock.disable_net_connect!
    PushPay.reset!
    PushPay.configure do |c|
      c.client_id = "test_client_id"
      c.client_secret = "test_client_secret"
      c.merchant_key = "test_merchant_key"
      c.organization_key = "test_org_key"
    end

    stub_request(:post, "https://auth.pushpay.com/pushpay/oauth/token")
      .to_return(
        status: 200,
        body: { access_token: "test_token", token_type: "bearer", expires_in: 3600 }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end

  config.after(:each) do
    WebMock.reset!
  end
end
