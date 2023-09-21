class Api::V1::ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 2
    products = Product.where(created_by: @current_user.id).paginate(page:, per_page:).order(id: :desc)
    total = products.count
    render json: {
      message: 'Successfully products are fetched!',
      data: {
        products:,
        total:
      }.as_json
    }, status: :ok
  rescue StandardError => e
    Rails.logger.error("Product index API failed: #{e.message}")
    render json: failed_response(e.message), status: :unprocessable_entity
  end

  def list
    page = params[:page] || 1
    per_page = params[:per_page] || 5
    title = params[:title] || ''
    category = params[:category] || ''
    product_option = params[:product_option] || ''
    price_minimum = params[:price_minimum] || ''
    price_maximum = params[:price_maximum] || ''
    price_option = params[:price_option] || ''
    products = Product.search(title, category, product_option, [price_minimum, price_maximum], price_option)
    total = products.count
    products = products.paginate(page:, per_page:).order(id: :desc)
    render json: {
      message: 'Successfully products are fetched!',
      data: {
        products:,
        total:
      }.as_json
    }, status: :ok
  rescue StandardError => e
    Rails.logger.error("Product browse API failed: #{e.message}")
    render json: failed_response(e.message), status: :unprocessable_entity
  end

  def show
    return render json: failed_response('Product not found'), status: :not_found unless @product.present?

    render json: {
      message: 'Successfully product is fetched!',
      data: @product.as_json
    }, status: :ok
  rescue StandardError => e
    Rails.logger.error("Product details API failed: #{e.message}")
    render json: failed_response(e.message), status: :unprocessable_entity
  end

  def create
    Product.create!(product_params.merge!(created_by: @current_user.id))
    render json: {
      message: 'Successfully product created!',
      data: nil
    }, status: :created
  rescue StandardError => e
    Rails.logger.error("Product create API failed: #{e.message}")
    render json: failed_response(e.message), status: :unprocessable_entity
  end

  def update
    return render json: failed_response('Product not found'), status: :not_found unless @product.present?

    @product.update!(product_params)
    render json: {
      message: 'Successfully product updated!',
      data: nil
    }, status: :ok
  rescue StandardError => e
    Rails.logger.error("Product update API failed: #{e.message}")
    render json: failed_response(e.message), status: :unprocessable_entity
  end

  def destroy
    return render json: failed_response('Product not found'), status: :not_found unless @product.present?

    @product.destroy!
    render json: {
      message: 'Successfully product deleted!',
      data: nil
    }, status: :ok
  rescue StandardError => e
    Rails.logger.error("Product destroy API failed: #{e.message}")
    render json: failed_response(e.message), status: :unprocessable_entity
  end

  def category_options
    categories = Setting.product_categories
    render json: {
      message: 'Successfully products are fetched!',
      data: categories
    }, status: :ok
  rescue StandardError => e
    Rails.logger.error("Product category option API failed: #{e.message}")
    render json: failed_response(e.message), status: :unprocessable_entity
  end

  def price_options
    price_options = Setting.price_options
    render json: {
      message: 'Successfully products are fetched!',
      data: price_options
    }, status: :ok
  rescue StandardError => e
    Rails.logger.error("Product category option API failed: #{e.message}")
    render json: failed_response(e.message), status: :unprocessable_entity
  end

  def my_products
    current_tab = params[:current_tab]
    products = case current_tab
               when 'bought'
                 Product.joins(:line_items).where(
                   'line_items.item_type = 1 and line_items.user_id = ? and line_items.item_owner_id != ?',
                   @current_user.id, @current_user.id
                 )
               when 'sold'
                 Product.joins(:line_items).where(
                   'line_items.item_type = 1 and line_items.user_id != ? and line_items.item_owner_id = ?',
                   @current_user.id, @current_user.id
                 )
               when 'borrowed'
                 Product.joins(:line_items).where(
                   'line_items.item_type = 2 and line_items.user_id = ? and line_items.item_owner_id != ?',
                   @current_user.id, @current_user.id
                 )
               when 'lent'
                 Product.joins(:line_items).where(
                   'line_items.item_type = 2 and line_items.user_id != ? and line_items.item_owner_id = ?',
                   @current_user.id, @current_user.id
                 )
               else
                 []
               end
    render json: {
      message: 'Successfully fetched',
      data: products.distinct.as_json
    }, status: :ok
  rescue StandardError => e
    Rails.logger.error("Product purchase/rent API failed: #{e.message}")
    render json: failed_response(e.message), status: :unprocessable_entity
  end

  def line_items
    product = Product.find_by(id: line_item_params[:product_id])
    return render json: failed_response('Product not found'), status: :not_found unless product.present?

    buy_price = line_item_params[:item_type] == 'buy' ? product.price : 0.0
    rent_price = line_item_params[:item_type] == 'rent' ? product.rental_price : 0.0
    rent_type = line_item_params[:item_type] == 'rent' ? product.price_option : nil
    params = line_item_params.merge!(
      user_id: @current_user.id,
      item_owner_id: product.created_by,
      buy_price:,
      rent_price:,
      rent_type:
    )
    LineItem.create!(params)
    render json: {
      message: "Successfully product is #{line_item_params[:item_type]}",
      data: nil
    }, status: :created
  rescue StandardError => e
    Rails.logger.error("Product #{line_item_params[:item_type]} API failed: #{e.message}")
    render json: failed_response(e.message), status: :unprocessable_entity
  end

  private

  def product_params
    params.permit(
      :title,
      :description,
      :price,
      :rental_price,
      :price_option,
      product_categories: []
    )
  end

  def line_item_params
    params.permit(
      :product_id,
      :item_type,
      :rental_time_start,
      :rental_time_end
    )
  end

  def set_product
    @product = Product.find_by(id: params[:id])
  end
end
