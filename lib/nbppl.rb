# frozen_string_literal: true

require "nbppl/version"
require "date"
require "uri"
require "net/http"
require "json"

module Nbppl
  class ErrorResponse < StandardError; end
  class Client
    NPB_PL_API_URL = "http://api.nbp.pl/api"

    def self.current
      @current ||= Client.new
    end

    def initialize
      @cache = Hash.new { |h,k| h[k] = {} }
    end

    def fetch_mid_rate(currency, date = Date.today)
      if @cache[currency].has_key?(date.to_s)
        return @cache[currency][date.to_s]
      end
      
      url = "#{NPB_PL_API_URL}/exchangerates/rates/a/#{currency}/#{date}?format=json"
      uri = URI(url)
      response = Net::HTTP.get_response(uri)
      
      rate = parse_response(response)
      @cache[currency][date.to_s] = rate && rate["rates"].first["mid"]
    end

    def closest_mid_rate(currency, date = Date.today)
      rate = nil
      until rate = fetch_mid_rate(currency, date)
        date -= 1
      end
      [rate, date]
    end

    private

    def parse_response(response)
      case response.code
      when "404" 
        nil
      when "200"
        JSON.parse(response.body)
      else
        message = "#{response.code}, #{response.body}".force_encoding("UTF-8")
        raise ErrorResponse.new(message)
      end
    end
  end
end
