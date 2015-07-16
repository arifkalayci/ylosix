# == Schema Information
#
# Table name: shopping_orders
#
#  billing_address  :hstore           default({}), not null
#  billing_commerce :hstore           default({}), not null
#  carrier_id       :integer
#  commerce_id      :integer
#  created_at       :datetime         not null
#  customer_id      :integer
#  id               :integer          not null, primary key
#  order_num        :integer          not null
#  shipping_address :hstore           default({}), not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_shopping_orders_on_customer_id  (customer_id)
#

class ShoppingOrder < ActiveRecord::Base
  include ArrayLiquid

  belongs_to :customer
  belongs_to :commerce
  has_many :shopping_orders_products

  def self.from_shopping_cart(sc, commerce)
    so = ShoppingOrder.new
    so.customer = sc.customer

    so.shipping_address = sc.shipping_address.fields
    so.billing_address = sc.billing_address.fields

    unless commerce.nil?
      so.commerce = commerce
      so.billing_commerce = commerce.billing_address
    end

    sc.shopping_carts_products.each do |scp|
      so.shopping_orders_products << scp.to_shopping_order
    end

    so
  end

  def total_taxes
    shopping_orders_products.inject(0) do |a, e|
      a + (e.retail_price - e.retail_price_pre_tax) * e.quantity
    end
  end

  def total_products
    shopping_orders_products.inject(0) { |a, e| a + e.quantity }
  end

  def total_retail_price_pre_tax
    products_prices = shopping_orders_products.map { |e| e.retail_price_pre_tax * e.quantity }
    products_prices.reduce(:+)
  end

  def total_retail_price
    products_prices = shopping_orders_products.map { |e| e.retail_price * e.quantity }
    products_prices.reduce(:+)
  end

  def to_liquid
    {
        'shopping_orders_products' => array_to_liquid(shopping_orders_products),
        'total_products' => total_products,
        'total_taxes' => total_taxes,
        'total_retail_price_pre_tax' => total_retail_price_pre_tax,
        'total_retail_price' => total_retail_price
    }
  end
end
