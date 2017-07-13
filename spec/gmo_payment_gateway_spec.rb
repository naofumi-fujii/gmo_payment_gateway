require "spec_helper"

RSpec.describe GmoPaymentGateway do
  it "has a version number" do
    expect(GmoPaymentGateway::VERSION).not_to be nil
  end

  let(:url)       { ENV["URL"] }
  let(:shop_id)   { ENV["SHOP_ID"] }
  let(:shop_pass) { ENV["SHOP_PASS"] }

  let(:client) { GmoPaymentGateway::Client.new(url, shop_id, shop_pass) }

  describe "GmoPaymentGateway::Client" do
    describe "#search_trade_multi" do
      subject { client.search_trade_multi(order_id, pay_type).body }

      context "pay_type" do

        context "0" do
          let(:pay_type) { "0" }
          let(:order_id)  { 'edbe52680697920d9ae75055ae' }
          it { is_expected.to have_key "Status" }
        end

        context "3" do
          let(:pay_type) { "3" }
          let(:order_id)  { 'a06676b132c707a3961253c159' }
          it { is_expected.to have_key "Status" }
        end

      end
    end
  end
end
