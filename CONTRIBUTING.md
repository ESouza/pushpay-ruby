# Contributing to PushPay Ruby

Thanks for your interest in contributing! Here's how to get started.

## Getting Started

1. Fork the repo on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/your-username/pushpay-ruby.git
   cd pushpay-ruby
   ```
3. Install dependencies:
   ```bash
   bundle install
   ```
4. Create a feature branch:
   ```bash
   git checkout -b my-feature
   ```

## Making Changes

- Write tests for any new functionality or bug fixes
- Run the test suite before submitting:
  ```bash
  bundle exec rspec
  ```
- Run the linter:
  ```bash
  bundle exec rubocop
  ```
- Keep commits focused — one logical change per commit

## Submitting a Pull Request

1. Push your branch to your fork:
   ```bash
   git push origin my-feature
   ```
2. Open a Pull Request against the `master` branch
3. Describe what your change does and why
4. Link any related issues

## Code Style

- Follow existing patterns in the codebase
- Use `frozen_string_literal: true` in all Ruby files
- Keep methods short and focused
- Let the PushPay API handle validation — avoid client-side validation

## Reporting Bugs

Open an issue on GitHub with:

- Ruby version (`ruby -v`)
- Gem version (`PushPay::VERSION`)
- Steps to reproduce
- Expected vs actual behavior

## Adding a New Resource

1. Create `lib/pushpay/resource_name.rb` inheriting from `PushPay::Base`
2. Add `require_relative` in `lib/pushpay.rb`
3. Create `spec/pushpay/resource_name_spec.rb` with WebMock stubs
4. Add a wiki page documenting the resource
5. Update `API-Reference.md` in the wiki

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
