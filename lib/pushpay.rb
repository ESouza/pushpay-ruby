# frozen_string_literal: true

require 'httparty'
require 'json'

require_relative 'pushpay/version'
require_relative 'pushpay/errors'
require_relative 'pushpay/configuration'
require_relative 'pushpay/client'
require_relative 'pushpay/base'
require_relative 'pushpay/payment'
require_relative 'pushpay/recurring_payment'
require_relative 'pushpay/anticipated_payment'
require_relative 'pushpay/merchant'
require_relative 'pushpay/organization'
require_relative 'pushpay/fund'
require_relative 'pushpay/settlement'
require_relative 'pushpay/batch'
require_relative 'pushpay/webhook'

module PushPay
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end

    def client
      @client ||= Client.new(configuration)
    end

    def reset!
      @client = nil
      @configuration = nil
    end
  end
end
