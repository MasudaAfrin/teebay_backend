class AddRentalPriceProduct < ActiveRecord::Migration[7.0]
  def change
    remove_column :products, :product_type, :integer
    add_column :products, :rental_price, :decimal, default: 0.0
  end
end
