class Product < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :created_by

  validates :title, :product_categories, :price, :price_option, presence: true

  scope :search_by_title, -> (title) { where('lower(title) LIKE ?', "%#{title.downcase}%") }
  scope :search_by_category, -> (category) { where("product_categories @> ?", "{#{category}}") }
  scope :search_by_price_range, -> (price_range) { where('price >= ? and price <= ?', price_range[0], price_range[1]) }
  scope :search_by_rental_price_range, -> (price_range) { where('rental_price >= ? and rental_price <= ?', price_range[0], price_range[1]) }
  scope :search_by_price_option, -> (price_option) { where('price_option = ?', price_option) }

  def self.search(title, category, product_option, price_range, price_option)
    products = Product.all
    if title.present?
      products = products.search_by_title(title)
    end
    if category.present?
      products = products.search_by_category(category)
    end
    if product_option.present? && product_option == 'buy' && price_range.present?
      products = products.search_by_price_range(price_range)
    end
    if product_option.present? && product_option == 'rent' && price_range.present? && price_option.present?
      products = products.search_by_rental_price_range(price_range).search_by_price_option(price_option)
    end
    products
  end
end
