class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :title
      t.string :description
      t.string :product_categories, array: true, default: []
      t.decimal :price, precision: 10, scale: 2
      t.integer :product_type, default: 0
      t.string :price_option
      t.timestamps
    end
  end
end
