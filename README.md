# PushPay Ruby

Ruby gem for integrating with the [PushPay](https://pushpay.com) payment processing API. Supports payments, recurring payments, anticipated payments, funds, merchants, organizations, settlements, batches, and webhooks.

## Installation

Add to your Gemfile:

```ruby
gem 'pushpay-ruby'
```

Then run:

```bash
bundle install
```

Or install directly:

```bash
gem install pushpay-ruby
```

## Configuration

```ruby
PushPay.configure do |config|
  config.client_id        = ENV['PUSHPAY_CLIENT_ID']
  config.client_secret    = ENV['PUSHPAY_CLIENT_SECRET']
  config.merchant_key     = ENV['PUSHPAY_MERCHANT_KEY']
  config.organization_key = ENV['PUSHPAY_ORGANIZATION_KEY']

  # Optional
  config.scopes  = %w[read merchant:view_payments]
  config.timeout = 30 # seconds, default

  # Use sandbox environment
  # config.sandbox!
end
```

## Usage

All resources can be initialized without arguments (uses `PushPay.client` by default) or with an explicit client.

### Payments

Payments are read-only in the PushPay API.

```ruby
payments = PushPay::Payment.new

# Get a single payment
payments.find('payment_token')

# List merchant payments with filters
payments.list(status: 'Success', pageSize: 10, from: '2024-01-01')

# List payments across an organization
payments.list_for_organization
```

### Recurring Payments

```ruby
recurring = PushPay::RecurringPayment.new

# Get a recurring payment
recurring.find('recurring_token')

# List recurring payments
recurring.list

# Get payments linked to a recurring schedule
recurring.payments('recurring_token')

# List across an organization
recurring.list_for_organization
```

### Anticipated Payments

Create payment links that can be sent to payers.

```ruby
anticipated = PushPay::AnticipatedPayment.new

# Create an anticipated payment
anticipated.create({ amount: '50.00' })

# List anticipated payments
anticipated.list
```

### Merchants

```ruby
merchants = PushPay::Merchant.new

# Get a specific merchant
merchants.find('merchant_key')

# Search merchants
merchants.search(name: 'Church')

# List accessible merchants
merchants.in_scope

# Search nearby
merchants.near(latitude: '37.7749', longitude: '-122.4194', country: 'US')
```

### Organizations

```ruby
orgs = PushPay::Organization.new

# Get an organization
orgs.find('org_key')

# List accessible organizations
orgs.in_scope

# List campuses
orgs.campuses

# List merchant listings
orgs.merchant_listings
```

### Funds

```ruby
funds = PushPay::Fund.new

# List funds for a merchant
funds.list

# List funds for an organization
funds.list_for_organization

# Get a specific fund
funds.find('fund_key')

# Create a fund
funds.create({ name: 'Missions', taxDeductible: true })

# Update a fund
funds.update('fund_key', { name: 'Updated Name' })

# Delete a fund
funds.delete('fund_key')
```

### Settlements

```ruby
settlements = PushPay::Settlement.new

# List settlements
settlements.list

# Get a specific settlement
settlements.find('settlement_key')

# Get payments within a settlement
settlements.payments('settlement_key')
```

### Batches

```ruby
batches = PushPay::Batch.new

# List batches
batches.list

# Get a specific batch
batches.find('batch_key')

# Get payments within a batch
batches.payments('batch_key')
```

### Webhooks

```ruby
webhooks = PushPay::Webhook.new

# List webhooks
webhooks.list

# Create a webhook
webhooks.create({ target: 'https://example.com/webhook', eventTypes: ['payment_created'] })

# Update a webhook
webhooks.update('webhook_token', { target: 'https://example.com/new' })

# Delete a webhook
webhooks.delete('webhook_token')
```

### Using a Custom Merchant/Organization Key

All merchant/org-scoped methods accept an optional key override:

```ruby
payments.list(merchant_key: 'other_merchant')
funds.list_for_organization(organization_key: 'other_org')
```

## Error Handling

```ruby
begin
  payments.list
rescue PushPay::ConfigurationError => e
  # Missing API credentials
rescue PushPay::AuthenticationError => e
  # OAuth authentication failed
rescue PushPay::ValidationError => e
  puts e.errors # Detailed validation failures
rescue PushPay::NotFoundError => e
  # 404 - Resource not found
rescue PushPay::RateLimitError => e
  puts e.retry_after # Seconds to wait
rescue PushPay::APIError => e
  puts e.status_code
  puts e.response_body
end
```

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).
