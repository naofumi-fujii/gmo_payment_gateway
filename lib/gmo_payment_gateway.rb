require "gmo_payment_gateway/version"
require "faraday"

module GmoPaymentGateway
  module Util
    ERROR_CODES = {
      "M01002002" => '指定されたIDとパスワードのショップが存在しません'
    }
  end

  class Response
    attr_reader *%i(raw_body)

    def initialize(faraday_response)
      @raw_body = faraday_response.body
    end

    def body
      CGI.parse(raw_body).map {|k, v| {k => v[0]}}.inject(&:merge)
    end

    def error?
      body.key? "ErrInfo"
    end

    def error_codes
      body["ErrInfo"].split '|'
    end

    def error_messages
      error_codes.map { |error_code| translate(error_code) }
    end

    def translate error_code
      GmoPaymentGateway::Util::ERROR_CODES[error_code]
    end
  end

  class Client
    attr_reader *%i(faraday shop_id shop_pass)

    def initialize(url, shop_id, shop_pass)
      @faraday   = Faraday.new(url: url)
      @shop_id   = shop_id
      @shop_pass = shop_pass
    end

    def search_trade_multi(order_id, pay_type)
      faraday_response = faraday.post '/payment/SearchTradeMulti.idPass', {
        ShopID:   shop_id,
        ShopPass: shop_pass,
        OrderID:  order_id,
        PayType:  pay_type,
      }

      GmoPaymentGateway::Response.new(faraday_response)
    end
  end
end
