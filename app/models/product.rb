class Product < ApplicationRecord
  enum product_type: { rent: 0, buy: 1 }

  validates :title, :product_categories, :price, :price_option, presence: true
end
