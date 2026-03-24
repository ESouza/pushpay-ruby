# frozen_string_literal: true

require 'base64'

module PushPay
  class Client
    include HTTParty

    attr_reader :configuration, :access_token, :token_expires_at

    def initialize(configuration)
      @configuration = configuration
      validate_configuration!
      @access_token = nil
      @token_expires_at = nil
    end

    def authenticate!
      credentials = Base64.strict_encode64("#{configuration.client_id}:#{configuration.client_secret}")

      scopes = configuration.scopes.empty? ? ["read"] : configuration.scopes
      body = { grant_type: 'client_credentials', scope: scopes.join(' ') }

      response = self.class.post(
        configuration.auth_url,
        body: body,
        headers: {
          'Authorization' => "Basic #{credentials}",
          'Content-Type' => 'application/x-www-form-urlencoded'
        },
        timeout: configuration.timeout
      )

      unless response.success?
        raise AuthenticationError, "Failed to authenticate: #{response.code} - #{response.body}"
      end

      @access_token = response['access_token']
      @token_expires_at = Time.now + (response['expires_in'] || 3600)
      @access_token
    end

    def get(path, params = {})
      request(:get, path, query: params)
    end

    def post(path, data = {})
      request(:post, path, body: data.to_json)
    end

    def put(path, data = {})
      request(:put, path, body: data.to_json)
    end

    def patch(path, data = {})
      request(:patch, path, body: data.to_json)
    end

    def delete(path)
      request(:delete, path)
    end

    private

    def validate_configuration!
      missing = configuration.missing_credentials
      raise ConfigurationError, missing unless missing.empty?
    end

    def ensure_authenticated!
      authenticate! if @access_token.nil? || token_expired?
    end

    def token_expired?
      @token_expires_at && Time.now >= @token_expires_at
    end

    def request(method, path, options = {})
      ensure_authenticated!

      url = "#{configuration.base_url}#{path}"
      request_options = {
        headers: auth_headers,
        timeout: configuration.timeout
      }

      if options[:query]
        request_options[:query] = options[:query]
      end

      if options[:body]
        request_options[:body] = options[:body]
        request_options[:headers] = request_options[:headers].merge('Content-Type' => 'application/json')
      end

      response = self.class.send(method, url, request_options)
      handle_response(response)
    end

    def auth_headers
      {
        'Authorization' => "Bearer #{@access_token}",
        'Accept' => 'application/hal+json'
      }
    end

    def handle_response(response)
      case response.code
      when 200, 201, 202, 204
        response.parsed_response
      when 401
        @access_token = nil
        @token_expires_at = nil
        raise AuthenticationError, "Authentication failed: #{response.body}"
      when 404
        raise NotFoundError.new("Resource not found", response.code, response.body)
      when 429
        retry_after = response.headers['retry-after']
        raise RateLimitError.new("Rate limit exceeded", response.code, response.body, retry_after)
      when 400, 422
        parsed = response.parsed_response || {}
        errors = parsed['validationFailures'] || {}
        raise ValidationError.new(
          parsed['message'] || 'Validation failed',
          response.code,
          response.body,
          errors
        )
      when 500..599
        raise APIError.new("Server error", response.code, response.body)
      else
        raise APIError.new("Unexpected response", response.code, response.body)
      end
    end
  end
end
