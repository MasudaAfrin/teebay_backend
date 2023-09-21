class AddCreatedBytoProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :created_by, :bigint
    add_index :products, :created_by
  end
end
