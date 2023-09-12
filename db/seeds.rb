# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
setting = {
  categories: %w[ELECTRONICS FURNITURE HOME APPLIANCES SPORTING GOODS OUTDOOR TOYS],
  rent_buy_options: %w[per_day per_hour per_month]
}
Setting.create!(app_setting: setting)