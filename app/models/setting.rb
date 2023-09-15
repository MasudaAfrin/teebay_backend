class Setting < ApplicationRecord
  def self.product_categories
    categories = Setting.first.app_setting['categories']
    categories.map.with_index do |cat, index|
      {
        id: index + 1,
        value: cat,
        label: cat
      }
    end
  end

  def self.price_options
    price_options = Setting.first.app_setting['rent_buy_options']
    price_options.map.with_index do |option, index|
      {
        id: index + 1,
        value: option,
        label: option.humanize
      }
    end
  end
end
