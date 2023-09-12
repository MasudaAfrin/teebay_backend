class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings do |t|
      t.json :app_setting, default: {}
      t.timestamps
    end
  end
end
