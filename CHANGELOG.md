# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2026-03-24

### Changed
- **Breaking:** Rewritten to match the actual PushPay API
- Authentication now uses the correct PushPay OAuth 2.0 endpoint (`auth.pushpay.com`) with Basic auth
- All endpoints use `/v1/` prefix and are scoped by merchant/organization key
- Configuration uses `client_id`/`client_secret` instead of `application_key`/`application_secret`
- Responses use HAL+JSON format (`application/hal+json`)
- Token expiration tracking with automatic re-authentication

### Added
- `sandbox!` configuration method for sandbox environment
- `scopes` configuration for OAuth scope requests
- `RecurringPayment` resource (list, find, linked payments)
- `AnticipatedPayment` resource (create, list)
- `Organization` resource (find, search, in_scope, campuses, merchant_listings)
- `Fund` resource (CRUD + status updates)
- `Settlement` resource (list, find, payments)
- `Batch` resource (list, find, payments)
- `Webhook` resource (CRUD)
- `NotFoundError` for 404 responses
- `RateLimitError` now includes `retry_after` value
- `Base` resource class with merchant/organization path helpers
- All resources default to `PushPay.client` when no client is passed
- `PATCH` support on the HTTP client

### Removed
- `Donation` resource (not a real PushPay API resource)
- `PaymentPlan` resource (replaced by `RecurringPayment`)
- `Transaction` resource (not a standalone PushPay API resource)
- `jwt` dependency (not needed)
- Hardcoded credentials from client
- Client-side validation on resources (let the API validate)

## [0.1.1] - 2024-12-01

### Added
- Initial scaffolding release

## [0.1.0] - 2024-11-15

### Added
- Initial release
