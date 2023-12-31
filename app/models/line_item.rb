class LineItem < ApplicationRecord
  belongs_to :user
  belongs_to :product
  belongs_to :item_owner, class_name: 'User', foreign_key: :item_owner_id

  enum item_type: { buy: 1, rent: 2 }

  validate :product_purchase

  private

  def product_purchase
    return unless item_owner_id == user_id

    errors.add(:base, 'users can not buy/rent their products!')
  end
end
