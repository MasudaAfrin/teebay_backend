class Product < ApplicationRecord
  validates :title, :product_categories, :price, :price_option, presence: true
end
