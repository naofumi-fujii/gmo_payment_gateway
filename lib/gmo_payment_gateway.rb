require "gmo_payment_gateway/version"
require "faraday"

module GmoPaymentGateway
  class Client
    class Response
      def initialize(response)
      end
    end

    attr_reader *%i(faraday shop_id shop_pass)

    def initialize(url, shop_id, shop_pass)
      @faraday   = Faraday.new(url: url)
      @shop_id   = shop_id
      @shop_pass = shop_pass
    end

    def search_trade_multi(order_id, pay_type)
      response = faraday.post '/payment/SearchTradeMulti.idPass', {
        ShopID:   shop_id,
        ShopPass: shop_pass,
        OrderID:  order_id,
        PayType:  pay_type,
      }

      Response.new response
    end
  end
end
