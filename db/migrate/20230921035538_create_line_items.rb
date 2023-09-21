class CreateLineItems < ActiveRecord::Migration[7.0]
  def change
    create_table :line_items do |t|
      t.references :product, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.integer :item_type
      t.bigint :item_owner_id
      t.date :rental_time_start
      t.date :rental_time_end
      t.decimal :buy_price, default: 0
      t.decimal :rent_price, default: 0
      t.string :rent_type
      t.timestamps
    end
  end
end
